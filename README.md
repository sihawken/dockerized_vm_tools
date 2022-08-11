# Dockerized QEMU/Libvirt

An eas[y/ier] way to set up QEMU/Libvirt/Looking-Glass/Scream with VFIO passthrough. This image can connect directly to your x session (or xWayland session) via cookie it adds to your host system. It can also play audio directly on your host system by passing an ALSA audio device created by pulseaudio or pipewire.

## Building the Environment

This requires a linux OS. These scripts were tested and functional for me on Pop! OS, however given the nature of docker this should function on most distributions.

You must have docker installed.

- `git clone https://github.com/sihawken/dockerized_vm_tools.git && cd dockerized_vm_tools`
- `sudo chmod +x Build_Docker_Container_Image.sh`
- `./Build_Docker_Container_Image.sh`

Add your XML files to /run/
