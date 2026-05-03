locals {
  talos = {
    version = "v1.13.0"
    schematicID = "ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515"
  }
  # - Hardware Type -> Cloud Server
  #- Choose Talos Linux Version -> 1.13.0
  # - Cloud -> NoCloud
  # - Machine Architecture -> amd64
  # - System Extensions -> iscsi-tools, qemu-guest-agent
  # - Customization -> auto
}

resource "proxmox_download_file" "talos_nocloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "prox3"

  file_name               = "talos-${local.talos.version}-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/${local.talos.schematicID}/${local.talos.version}/nocloud-amd64.raw.xz"
  decompression_algorithm = "zst"
  overwrite               = false
}