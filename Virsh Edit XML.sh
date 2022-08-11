#!/bin/bash

read -p "Enter VM name to edit: " vm_name

docker exec -ti vm virsh edit $vm_name
