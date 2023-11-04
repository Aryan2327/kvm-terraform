#!/bin/bash

guest_machines=($(virsh list --all | awk 'NF && NR>1 {print $2}'))
for i in "${guest_machines[@]}"
do
  virsh start $i
done
