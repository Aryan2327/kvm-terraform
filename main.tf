terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

locals {
  subnet = "192.168.1.0/24"
}

resource "libvirt_pool" "ubuntu_pool" {
  name = "ubuntu_pool"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

resource "libvirt_network" "kube_network" {
  name = "k8snet"
  domain = var.domain
  autostart = true
  mode = "nat"
  addresses = [local.subnet]
  dhcp {
    enabled = false
  }

  dnsmasq_options {
    options {
      option_name = "server"
      option_value = "/${var.domain}/${cidrhost(local.subnet, 1)}"
    }
  }
}

module "libvirt_workers" {
  source = "./modules/worker_nodes"
  master_vm_count = var.master_vm_count
  worker_vm_count = var.worker_vm_count
  worker_hostnames = var.worker_hostnames
  pool_name = libvirt_pool.ubuntu_pool.name
  ssh_pubkey = var.ssh_pubkey
  username = var.username
  ubuntu_image_source = var.ubuntu_image_source
  network_name = libvirt_network.kube_network.name
  subnet = local.subnet
  domain = var.domain
}

module "libvirt_masters" {
  source = "./modules/master_nodes"
  master_vm_count = var.master_vm_count
  master_hostnames = var.master_hostnames
  pool_name = libvirt_pool.ubuntu_pool.name
  ssh_pubkey = var.ssh_pubkey
  username = var.username
  ubuntu_image_source = var.ubuntu_image_source
  network_name = libvirt_network.kube_network.name
  subnet = local.subnet
  domain = var.domain
}
