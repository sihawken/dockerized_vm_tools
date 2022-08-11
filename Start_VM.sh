#!/bin/bash

echo "Here are all the VMs available to run on the system."
echo ""

export res1=`docker exec vm virsh list --all`
echo "$res1"
echo ""

read -p "Enter VM to start: " vm_name
echo ""

if [[ "$vm_name" == "" ]]; then
    
    # If no input is givent, do nothing.
    echo "No VM selected."
    echo ""
    
elif [[ "$(echo "$res1" | grep -w " $vm_name ")" == "" ]]; then
    
    # If the VM that was selected is not on the list, do nothing.
    echo "Selected VM not in list."
    echo ""
    
elif [[ "$(echo "$(echo "$res1" | grep -w " $vm_name ")" | grep "shut off")" != "" ]]; then
    
    # If the VM that was selected is on the list and is in a shut off state, start the VM.
    echo "Attempting to start VM $vm_name..."
    echo ""
    
    export res2=`docker exec vm virsh start $vm_name`
    
    echo "VIRSH OUTPUT >> $res2"
    echo ""
    
elif [[ "$(echo "$(echo "$res1" | grep -w " $vm_name ")" | grep "running")" != "" ]]; then
    
    # If the VM that was selected is on the list and is in a running state, do nothing.
    echo "Selected VM $vm_name is already running."
    echo ""
    
else
     # Lastly, if if the VM is in an errored/unrecognized state, let the user know, do nothing.
    echo "Selected VM $vm_name is in an errored/unrecognized state."
    echo ""

fi

echo "Closing in 5 seconds..."
sleep 5
