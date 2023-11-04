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
  count = var.master_vm_count
  name = "master${count.index}_commoninit.iso"
  pool = var.pool_name
  user_data = templatefile("${path.root}/cloud_init.cfg", {ssh_pubkey = var.ssh_pubkey, username = var.username, hostname = "${var.master_hostnames[count.index]}.${var.domain}"})
}

resource "libvirt_volume" "ubuntu_image" {
  count = var.master_vm_count
  name = "ubuntu_amd64_master${count.index}"
  pool = var.pool_name
  source = var.ubuntu_image_source
}

resource "libvirt_domain" "kvm_master" {
  count = var.master_vm_count
  name = var.master_hostnames[count.index]
  description = "Kvm VM (Master Node ${count.index})"
  vcpu = 2
  memory = 2048
  running = "true"
  disk {
    volume_id = libvirt_volume.ubuntu_image[count.index].id
  }
  network_interface {
    network_name = var.network_name
    hostname = var.master_hostnames[count.index]
    addresses = [cidrhost(var.subnet, count.index+2)]
    wait_for_lease = false
  }
  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
}

