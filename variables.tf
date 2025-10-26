variable "cluster_name" {
  type    = string
  default = "homelab"
}

variable "default_gateway" {
  type    = string
  default = "192.168.64.1"
}

variable "talos_cp_01_ip_addr" {
  type    = string
  default = "192.168.64.30"
}

variable "talos_worker_ips" {
  type = list(string)
  default = ["192.168.64.31",
    "192.168.64.32",
    "192.168.64.33",
    "192.168.64.34",
    "192.168.64.35",
  "192.168.64.36"]
}

# variable "talos_worker_01_ip_addr" {
#   type    = string
#   default = "192.168.64.31"
# }

# variable "talos_worker_02_ip_addr" {
#   type    = string
#   default = "192.168.64.32"
# }