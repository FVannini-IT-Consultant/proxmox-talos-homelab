locals {
  talos = {
    version = "v1.13.0"
  }
}

resource "proxmox_download_file" "talos_nocloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "prox3"

  file_name               = "talos-${local.talos.version}-nocloud-amd64.img"
  #url                     = "https://factory.talos.dev/image/dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586/${local.talos.version}/nocloud-amd64.raw.xz"
  url                     = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/${local.talos.version}/nocloud-amd64.raw.xz"
  #url                     = "https://factory.talos.dev/image/c9078f9419961640c712a8bf2bb9174933dfcf1da383fd8ea2b7dc21493f8bac/v1.11.5/nocloud-amd64.raw.xz" # nocloud with iSCSI
  #url                     = "https://factory.talos.dev/image/c9078f9419961640c712a8bf2bb9174933dfcf1da383fd8ea2b7dc21493f8bac/v1.12.2/nocloud-amd64.raw.xz" # nocloud with iSCSI
  decompression_algorithm = "zst"
  overwrite               = false
}