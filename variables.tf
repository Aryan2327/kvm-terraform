variable "ubuntu_image_source" {
  type = string
  default = "./images/ubuntu_cloud.img"
  description = "Relative or remote source of Ubuntu OS image"
}

variable "worker_vm_count" {
  type = number
  default = 1
  description = "Numbers of worker vms"
}


variable "master_vm_count" {
  type = number
  default = 1
  description = "Number of master vms"
}

variable "username" {
  type = string
  description = "Default user for guest machines"
}

variable "ssh_pubkey" {
  type = string
  description = "SSH public key to propagate to guest machines"
}

variable "worker_hostnames" {
  type = list(string)
  description = "List of worker vm hostnames. Should be consistent with worker_vm_count"
}

variable "master_hostnames" {
  type = list(string)
  description = "List of master vm hostnames. Should be consistent with master_vm_count"
}

variable "domain" {
  type = string
  description = "Domain for guest machines"
}
