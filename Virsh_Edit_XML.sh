#!/bin/bash

echo "Here are all the VMs currently available to run on the system."
echo ""

export res1=`docker exec vm virsh list --all`
echo "$res1"
echo ""

read -p "Enter VM name to edit: " vm_name

docker exec -ti vm virsh edit $vm_name
