#!bin/bash

while [[ "true" == "true" ]];
do
    VIRSH_OUTPUT="$(virsh net-list --all)"
    
    if [[ "$(echo "$VIRSH_OUTPUT" | grep " default " | grep " active ")" == "" ]]; then
        
        echo "Default network is not running. Starting the default network."
        
        VIRSH_NETSTART_OUTPUT="$(virsh net-start default)"
        echo "VIRSH OUTPUT >> $VIRSH_NETSTART_OUTPUT"
        
    else
    	echo "Default network is already running. Sleeping for 10 seconds."      
    fi
     
    sleep 10
    
done
