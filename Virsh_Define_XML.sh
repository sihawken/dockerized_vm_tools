#!/bin/bash

echo "Here are all the VMs currently available to run on the system."
echo ""

export res1=`docker exec vm virsh list --all`
echo "$res1"
echo ""

read -p "Enter XML filename to define a new VM configuration (do not add .xml to the end of the filename): " vm_filename

docker exec -ti vm virsh define /etc/libvirt/qemu/$vm_filename.xml

echo "Closing in 10 seconds..."

sleep 10
