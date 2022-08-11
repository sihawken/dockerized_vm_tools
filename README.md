# Dockerized QEMU/Libvirt/Looking-Glass/Scream

An eas[y/ier] way to set up QEMU/Libvirt/Looking-Glass/Scream with VFIO passthrough. 

This image and these scripts can connect directly to your x session (or xWayland session) via cookie it adds to your host system. It can also play audio directly on your host system by passing an ALSA audio device created by pulseaudio or pipewire.

## Build and Start the Environment

This requires a linux OS. These scripts were tested and functional for me on Pop! OS, however given the nature of docker this should function on most distributions.

You must have docker installed. Build and start the environment with the following commands:

- `git clone https://github.com/sihawken/dockerized_vm_tools.git && cd dockerized_vm_tools`
- `sudo chmod +x Build_Docker_Container_Image.sh`
- `./Build_Docker_Container_Image.sh`
- `sudo chmod +x Create_and_Start_Container.sh`
- `./Create_and_Start_Container.sh`

The container named "vm" should now successfully be running.

## Setting up a VM

This image has virt-manager on it. Start virt-manager by the following commands:

- `sudo chmod +x Start_Virt-Manager.sh`
- `./Start_Virt-Manager.sh`
