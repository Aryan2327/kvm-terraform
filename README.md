# Kubernetes Homelab

## Table of Contents

## Introduction

This is a tool for setting up a on-prem Kubernetes cluster via KVM virtualization. KVM guest machines are spun up via Terraform and cloud-init; machine provisioning is performed via Ansible.

Note that this is only intended for Ubuntu machines.

## Installation

An Ansible role is provided to install the necessary packages onto the hypervisor and make configuration changes necessary for the KVM and virtual NAT networking to perform correctly.

To set up the host machine, do the following:

1. Install repository dependencies (terraform, libvirt, ...)

2. Install Linux cloud image

	$ chmod +x ./scripts/install_cloud_image.sh && ./scripts/install_image.sh

Note that the source image and preferred size of guest vms can be specified within the script.
...

## Usage

...

## Extra Notes

Using the nss-libvirt package to resolve libvirt kvm vm hostnames to ips.
