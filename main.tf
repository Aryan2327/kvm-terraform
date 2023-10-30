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

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "commoninit.iso"
  pool = libvirt_pool.ubuntu_pool.name
  user_data = templatefile("${path.module}/cloud_init.cfg", {ssh_pubkey = var.ssh_pubkey, username = var.username})
}

resource "libvirt_pool" "ubuntu_pool" {
  name = "ubuntu_pool"
  type = "dir"
  path = "/var/lib/libvirt/images" 
}

resource "libvirt_volume" "ubuntu_image" {
  count = var.vm_count
  name = "ubuntu_amd64_guest${count.index}"
  pool = libvirt_pool.ubuntu_pool.name
  source = var.ubuntu_image_source
}

//resource "null_resource" "libvirt_network" {
//  provisioner "local-exec" {
//    command = "virsh net-define ${path.module}/libvirt_custom_network.xml && virsh net-start libvirt_custom_network"
//  }

//  provisioner "local-exec" {
//    when = destroy
//    command = "virsh net-destroy libvirt_custom_network && virsh net-undefine libvirt_custom_network"
//  }
//}

resource "libvirt_network" "kube_network" {
  name = "k8snet"
  domain = var.domain
  autostart = true
  mode = "nat"
  addresses = [local.subnet]
  dns {
    local_only = true
    dynamic "hosts" {
      for_each = var.hostnames
      content {
        ip = cidrhost(local.subnet, hosts.key+2)
        hostname = hosts.value
      }
    }
  }
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

resource "libvirt_domain" "kvm_guest" {
  count = var.vm_count
  name = var.hostnames[count.index]
  description = "Kvm VM (Node ${count.index})"
  vcpu = 1
  memory = 2048
  running = "true"
  disk {
    volume_id = libvirt_volume.ubuntu_image[count.index].id
  }
  network_interface {
    network_name = libvirt_network.kube_network.name
    hostname = var.hostnames[count.index]
    addresses = [cidrhost(libvirt_network.kube_network.addresses[0], count.index+2)]
    wait_for_lease = false
  }
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  //depends_on = [
    //null_resource.libvirt_network
  //]
}
