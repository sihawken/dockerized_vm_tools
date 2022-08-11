# Dockerized QEMU/Libvirt/Looking-Glass/Scream

An eas[y/ier] way to set up QEMU/Libvirt/Looking-Glass/Scream with VFIO passthrough. 

This image and these scripts can connect directly to your x session (or xWayland session) via cookie it adds to your host system. It can also play audio directly on your host system by passing an ALSA audio device created by pulseaudio or pipewire.

These scripts are still far from perfect, and there are a lot of improvements that can be made to make setting up this environment easier! Pull requests are welcome.

## Build and Start the Environment

This requires a linux OS. These scripts were tested and functional for me on Pop! OS, however given the nature of docker this should function on most distributions.

You must have docker installed. Build and start the environment with the following commands:

- `git clone https://github.com/sihawken/dockerized_vm_tools.git && cd dockerized_vm_tools`
- `sudo chmod +x Build_Docker_Container_Image.sh`
- `./Build_Docker_Container_Image.sh`
- `sudo chmod +x Create_and_Start_Container.sh`
- `./Create_and_Start_Container.sh`

The container named "vm" should now successfully be running.

## Setting Up a VM

The images that run in this environment have a few requirements.

- The shared Looking-Glass memory device must be named win10-looking-glass
- You must install Looking-Glass version B5.0.1 in the Windows guest
- You must install Scream version 3.9 in the Windows guest.

Only one VM can run at a time. Feel free to modify the environment for your own purposes if you plan on running multiple VMs at once.

### Virt-Manager

This image has virt-manager on it. Start virt-manager by the following commands:

- `sudo chmod +x Start_Virt-Manager.sh`
- `./Start_Virt-Manager.sh`

XML editing is not functional at this time in Virt-Manager for reasons I cannot determine. However, there is another script that will allow you to edit an xml file via the nano editor.

### Virsh Edit XML

You can edit the XML files in the container with this simple script.

- `sudo chmod +x Virsh_Edit_XML.sh`
- `./Virsh_Edit_XML.sh`

### Edit XML Manually

The XML files can be found in run/qemu_xml/. Since it is easy to access this way, you can manually edit or add any new xml files here.

If a new .xml is added, or an edited .xml is no longer listed on the list of VMs, the following scripts need to be run:

- `sudo chmod +x Virsh_Define_XML.sh`
- `./Virsh_Define_XML.sh`
