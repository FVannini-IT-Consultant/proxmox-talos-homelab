terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}
