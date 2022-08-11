#!/bin/bash

read -p "Enter XML filename to define (do not add .xml to the end of the filename): " vm_filename

docker exec -ti vm virsh define /etc/libvirt/qemu/$vm_filename.xml

echo "Closing in 10 seconds..."

sleep 10
