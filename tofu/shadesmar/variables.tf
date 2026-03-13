variable "proxmox_endpoint" {
    type = string
}

variable "proxmox_username" {
    type = string
}

variable "proxmox_token" {
    type = string
}

variable "proxmox_node_name" {
    type = string
}

variable "talos_image_schematic_id" {
    type = string
    description = "Talos image schematic ID from Talos Linux Image Factory"
}

variable "talos_version" {
    type = string
    description = "Talos version, format ex: v1.12.5"
}