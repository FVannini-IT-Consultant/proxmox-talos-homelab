locals {
  worker_ips = var.talos_worker_ips
}

resource "proxmox_virtual_environment_vm" "talos_cp" {
  count       = length(var.talos_cp_ips)
  vm_id       = var.start_vm_id + count.index
  name        = format("talos-cp-%02d", count.index + 1)
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = "prox3"
  on_boot     = true

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "fast"
    file_id      = proxmox_download_file.talos_nocloud_image.id
    file_format  = "raw"
    interface    = "virtio0"
    size         = 20
  }
  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = "fast"
    ip_config {
      ipv4 {
        address = "${var.talos_cp_ips[count.index]}/24"
        gateway = var.default_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }
}

resource "proxmox_virtual_environment_vm" "talos_worker" {
  count       = length(local.worker_ips)
  depends_on  = [proxmox_virtual_environment_vm.talos_cp]
  vm_id       = var.start_vm_id + count.index + 3
  name        = format("talos-worker-%02d", count.index + 1)
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = "prox3"
  on_boot     = true

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "fast"
    file_id      = proxmox_download_file.talos_nocloud_image.id
    file_format  = "raw"
    interface    = "virtio0"
    size         = 20
  }
  # disk {
  #   datastore_id = "Synology-iSCSI-Vol"
  #   file_format  = "raw"
  #   interface    = "virtio1"
  #   size         = var.talos_worker_data_disk_size
  # }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = "fast"
    ip_config {
      ipv4 {
        address = "${local.worker_ips[count.index]}/24"
        gateway = var.default_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }
}
