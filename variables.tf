variable "cluster_name" {
  type    = string
  default = "homelab"
}

variable "default_gateway" {
  type    = string
  default = "192.168.64.1"
}

variable "start_vm_id" {
  type    = number
  default = 1600
}

variable "talos_vip" {
  type    = string
  default = "192.168.64.30"
}

variable "talos_cp_ips" {
  type    = list(string)
  default = ["192.168.64.31","192.168.64.32", "192.168.64.33"]
}

variable "talos_worker_ips" {
  type = list(string)
  default = ["192.168.64.34","192.168.64.35","192.168.64.36","192.168.64.37","192.168.64.38","192.168.64.39"]
}
