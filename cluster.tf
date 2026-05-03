locals {
  artifact_dir = "${path.root}/_out"
}

resource "talos_machine_secrets" "machine_secrets" {}

data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = var.talos_cp_ips  # HA ControlPlane IPs
}

data "talos_machine_configuration" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.talos_vip}:6443"  # HA ControlPlane IPs
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "cp_config_apply" {
  depends_on                  = [proxmox_virtual_environment_vm.talos_cp]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_cp.machine_configuration
  count                       = length(var.talos_cp_ips)
  node                        = var.talos_cp_ips[count.index]
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk = "/dev/sdd"
        }
        network = {
          interfaces = [
            {
              interface = "eth0"
              vip = {
                ip = var.talos_vip
              }
            }
          ]
        }
      }
    })
  ]
}

data "talos_machine_configuration" "machineconfig_worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.talos_cp_ips[0]}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "worker_config_apply" {
  depends_on                  = [proxmox_virtual_environment_vm.talos_worker]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_worker.machine_configuration
  count                       = length(var.talos_worker_ips)
  node                        = var.talos_worker_ips[count.index]
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk = "/dev/sdd"
        }
      }
    })
  ]
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = var.talos_cp_ips[0] # bootstrap from first CP only
}

data "talos_cluster_health" "health" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply, talos_machine_configuration_apply.worker_config_apply]
  client_configuration = data.talos_client_configuration.talosconfig.client_configuration
  control_plane_nodes  = var.talos_cp_ips
  worker_nodes         = var.talos_worker_ips
  endpoints            = data.talos_client_configuration.talosconfig.endpoints
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap, data.talos_cluster_health.health]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = var.talos_cp_ips[0]
}

resource "local_sensitive_file" "talosconfig" {
  filename        = "${local.artifact_dir}/talosconfig.yaml"
  content         = data.talos_client_configuration.talosconfig.talos_config
  file_permission = "0600"
}

resource "local_sensitive_file" "kubeconfig" {
  filename        = "${local.artifact_dir}/kubeconfig.yaml"
  content         = talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  file_permission = "0600"
}

output "talosconfig" {
  value     = data.talos_client_configuration.talosconfig.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}
