variable "master_vm_count" {
  type = number
  description = "Number of master vms"
}

variable "worker_vm_count" {
  type = number
  description = "Number of worker vms"
}

variable "worker_hostnames" {
  type = list(string)
  description = "List of worker vm hostnames"
}

variable "pool_name" {
  type = string
  description = "Storage pool name"
}

variable "ssh_pubkey" {
  type = string
  description = "SSH public key"
}

variable "username" {
  type = string
  description = "Username"
}

variable "ubuntu_image_source" {
  type = string
  description = "Relative or remote source of Ubuntu OS image"
}

variable "network_name" {
  type = string
  description = "Name of custom network"
}

variable "subnet" {
  type = string
  description = "VM subnet"
}

variable "domain" {
  type = string
  description = "VM domain name"
}

