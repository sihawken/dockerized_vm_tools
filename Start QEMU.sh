#!/bin/bash

export CWD=`pwd`
export USER_UID=$(id -u)

xauth add "$DISPLAY" MIT-MAGIC-COOKIE-1 edeb96420d550bfa2b5b6ce949a2037a

if [[ "$(docker ps -aq -f name=^vm$)" == "" ]]; then

    # If the container hasn't been created yet
    docker run \
    --name vm \
    --userns host \
    --privileged \
    --cgroupns=host \
    --security-opt seccomp=unconfined \
    --group-add audio \
    -e "PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native" \
    -e "DISPLAY=$DISPLAY" \
    -e "XAUTH_COOKIE=edeb96420d550bfa2b5b6ce949a2037a" \
    --volume "${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native" \
    --volume "${HOME}/.config/pulse/cookie:/root/.config/pulse/cookie" \
    --volume "/sys/fs/cgroup:/sys/fs/cgroup:rw" \
    --volume "/dev/:/dev" \
    --volume "/tmp/.X11-unix/:/tmp/.X11-unix/" \
    --volume "/lib/modules/:/lib/modules/" \
    --volume "$CWD/run/qemu_xml/:/etc/libvirt/qemu/" \
    --volume "$CWD/drive_images/:/var/lib/libvirt/images/" \
    --volume "$CWD/run/acpi:/var/lib/libvirt/qemu/acpi/" \
    --volume "$CWD/run/hooks/:/etc/libvirt/hooks/" \
    --volume "$CWD/iso:/iso" \
    --network virtual_machines_dockerized_network \
    --detach \
    virtual_machines_dockerized
    
    echo "VM container created and started."

else
    # If the container has already been created
    echo "VM container already created, starting container"
    docker container start vm
fi

echo "Closing in 5 seconds..."

sleep 5
