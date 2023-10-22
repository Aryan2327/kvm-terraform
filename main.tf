terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "commoninit.iso"
  pool = libvirt_pool.ubuntu_pool.name
  user_data = templatefile("${path.module}/cloud_init.cfg", {ssh_pubkey = var.ssh_pubkey})
}

resource "libvirt_pool" "ubuntu_pool" {
  name = "ubuntu_pool"
  type = "dir"
  path = "/var/lib/libvirt/images" 
}

resource "libvirt_volume" "ubuntu_image" {
  name = "ubuntu_amd64"
  pool = libvirt_pool.ubuntu_pool.name
  source = var.ubuntu_image_source
}

resource "libvirt_domain" "kvm_guest" {
  count = var.vm_count
  name = "guest${count.index}"
  description = "Kvm VM (Node 0)"
  vcpu = 1
  memory = 2048
  running = "true"
  disk {
    volume_id = libvirt_volume.ubuntu_image.id
  }
  network_interface {
    network_name = "default"
  }
  cloudinit = libvirt_cloudinit_disk.commoninit.id 
}
