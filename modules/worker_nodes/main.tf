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
  count = var.worker_vm_count
  name = "worker${count.index}_commoninit.iso"
  pool = var.pool_name
  user_data = templatefile("${path.root}/cloud_init.cfg", {ssh_pubkey = var.ssh_pubkey, username = var.username, hostname = "${var.worker_hostnames[count.index]}.${var.domain}"})
}

resource "libvirt_volume" "ubuntu_image" {
  count = var.worker_vm_count
  name = "ubuntu_amd64_worker${count.index}"
  pool = var.pool_name
  source = var.ubuntu_image_source
}

resource "libvirt_domain" "kvm_worker" {
  count = var.worker_vm_count
  name = var.worker_hostnames[count.index]
  description = "Kvm VM (Worker Node ${count.index})"
  vcpu = 1
  memory = 2048
  running = "true"
  disk {
    volume_id = libvirt_volume.ubuntu_image[count.index].id
  }
  network_interface {
    network_name = var.network_name
    hostname = var.worker_hostnames[count.index]
    addresses = [cidrhost(var.subnet, count.index+var.master_vm_count+2)]
    wait_for_lease = false
  }
  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
}

