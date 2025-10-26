provider "proxmox" {
  endpoint = "https://prox3.francesco.va:8006/"
  insecure = true # Only needed if your Proxmox server is using a self-signed certificate
}