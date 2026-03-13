terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.98.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint

  username = var.proxmox_username
  password = var.proxmox_token
}

resource "proxmox_virtual_environment_download_file" "talos_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node_name
  url          = "https://factory.talos.dev/image/${var.talos_image_schematic_id}/${var.talos_version}/nocloud-amd64.iso"
}

resource "proxmox_virtual_environment_vm" "silverlight" {
  name      = "silverlight"
  node_name = var.proxmox_node_name
  vm_id = 160

  description = "Managed by Terraform"
  machine     = "q35"
  bios        = "ovmf"
  started     = true

  # Always set stop_on_destroy when started = true,
  # otherwise Terraform will attempt a graceful ACPI shutdown
  # that may hang if the guest agent is not installed.
  stop_on_destroy = true

  scsi_hardware = "virtio-scsi-pci"

  cpu {
    cores = 4
    type = "host"
  }

  memory {
    dedicated = 4096

    # Disables memory ballooning
    floating = 0
  }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_image.id
    interface = "ide2"
  }

  efi_disk {
    datastore_id = "local-lvm"
    type         = "4m"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 32
    file_format = "raw"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
    mac_address = "bc:24:11:95:31:7d"
  }

  agent {
    enabled = true
  }
}

resource "proxmox_virtual_environment_vm" "azimir" {
  name      = "azimir"
  node_name = var.proxmox_node_name
  vm_id = 161

  description = "Managed by Terraform"
  machine     = "q35"
  bios        = "ovmf"
  boot_order = [ "virtio0", "ide2" ]
  started     = true

  # Always set stop_on_destroy when started = true,
  # otherwise Terraform will attempt a graceful ACPI shutdown
  # that may hang if the guest agent is not installed.
  stop_on_destroy = true

  scsi_hardware = "virtio-scsi-pci"

  cpu {
    cores = 4
    type = "host"
  }

  memory {
    dedicated = 4096

    # Disables memory ballooning
    floating = 0
  }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_image.id
    interface = "ide2"
  }

  efi_disk {
    datastore_id = "local-lvm"
    type         = "4m"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 32
    file_format = "raw"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
    mac_address = "bc:24:11:06:55:97"
  }

  agent {
    enabled = true
  }
}


