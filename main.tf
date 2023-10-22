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

resource "libvirt_domain" "kvm_guest" {
  count = var.vm_count
  name = "guest${count.index}"
  description = "Kvm VM (Node ${count.index})"
  vcpu = 1
  memory = 2048
  running = "true"
  disk {
    volume_id = libvirt_volume.ubuntu_image[count.index].id
  }
  network_interface {
    network_name = "default"
  }
  cloudinit = libvirt_cloudinit_disk.commoninit.id 
}
