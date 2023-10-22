variable "ubuntu_image_source" {
  type = string
  default = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img"
  description = "Relative or remote source of Ubuntu OS image"
}

variable "vm_count" {
  type = number
  default = 1
  description = "Numbers of guest vms to create"
}

variable "username" {
  type = string
  description = "Default user for guest machines"
}

variable "ssh_pubkey" {
  type = string
  description = "SSH public key to propagate to guest machines"
}
