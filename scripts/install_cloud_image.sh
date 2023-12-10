#!/bin/bash

CLOUD_IMAGE=https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img
DEST_FILE=$(git rev-parse --show-toplevel)/images/ubuntu_cloud.img
SIZE=+20G # +/- refers to growing/shrinking image relative to the base size of the cloud image

wget -O $DEST_FILE $CLOUD_IMAGE
qemu-img resize $DEST_FILE $SIZE
