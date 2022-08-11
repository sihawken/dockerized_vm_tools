FROM debian:bullseye-slim AS prepimage

ENV LOOKING_GLASS_VER="B5.0.1"
ENV SCREAM_VER="3.9"

RUN export DEBIAN_FRONTEND=noninteractive

FROM prepimage AS buildimage

RUN apt-get -qq update -y && \
    apt-get -qq install -y binutils-dev cmake fonts-dejavu-core libfontconfig-dev gcc g++ pkg-config libegl-dev libgl-dev libgles-dev libspice-protocol-dev nettle-dev libx11-dev libxcursor-dev libxi-dev libxinerama-dev libxpresent-dev libxss-dev libxkbcommon-dev libwayland-dev wayland-protocols wget gnupg time ca-certificates
    
FROM buildimage AS looking_glass_buildimage

# Download looking glass
RUN wget https://looking-glass.io/artifact/${LOOKING_GLASS_VER}/source -O looking-glass-${LOOKING_GLASS_VER}.tar.gz

RUN tar -xvf looking-glass-${LOOKING_GLASS_VER}.tar.gz && \
    cd looking-glass-${LOOKING_GLASS_VER}/client/ && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make
    
FROM buildimage AS scream_buildimage

# Download libasound2-dev to enable output to alsa
RUN apt-get -qq update -y && \
    apt-get -qq install -y libasound2-dev

RUN wget https://github.com/duncanthrax/scream/archive/refs/tags/${SCREAM_VER}.tar.gz -O scream-${SCREAM_VER}.tar.gz

RUN tar -xvf scream-${SCREAM_VER}.tar.gz && \
    cd scream-${SCREAM_VER}/Receivers/unix && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make
    
FROM prepimage AS runimage

# Setting up base operating system
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -qq update -y && \
    apt-get -qq install -y --no-install-recommends apt-utils gnupg time locales nano dnsmasq supervisor axel xauth && \
    rm -rf /var/lib/apt/lists
    
# Add Tini init system
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Setting up the locales
RUN echo 'en_US ISO-8859-1' >> /etc/locale.gen && \
    echo 'en_US.ISO-8859-15 ISO-8859-15' >> /etc/locale.gen && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
    locale-gen

# Installing KVM and pulseaudio for scream
RUN apt-get -qq update -y && \
    apt-get -qq install -y --no-install-recommends qemu qemu-system qemu-kvm libvirt-daemon libvirt-daemon-system libvirt-clients libguestfs-tools libosinfo-bin bridge-utils virt-manager virtinst ovmf gir1.2-spiceclientgtk-3.0 && \
    apt-get -qq install -y pulseaudio && \
    rm -rf /var/lib/apt/lists
    
RUN apt-get -qq update -y && \
    apt-get -qq install -y libxss1 libxpresent1 libegl1 libgl1 && \
    rm -rf /var/lib/apt/lists

# Add VFIO libvirt hooks utility
RUN wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' -O /etc/libvirt/hooks/qemu && \
    chmod +x /etc/libvirt/hooks/qemu

# Generating a universally unique ID for the Container
RUN  dbus-uuidgen > /etc/machine-id

# Creating .Xauthority file to forward x session to host
RUN touch /root/.Xauthority

# Import supervisord configuration file
COPY supervisord.conf /etc/supervisord.conf

# Copy the built looking-glass binary to the runimage
COPY --from=looking_glass_buildimage looking-glass-${LOOKING_GLASS_VER}/client/build/looking-glass-client /bin/looking-glass-client
# Add user to run looking-glass with
RUN useradd -ms /bin/bash looking-glass

# Copy the built scream binary to the runimage
COPY --from=scream_buildimage scream-${SCREAM_VER}/Receivers/unix/build/scream /bin/scream

# Copy script to ensure that the default network is always running.
COPY checknetwork.sh /checknetwork.sh

# Add the entrypoint script to ensure permissions and display varaibles are correct
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

CMD ["supervisord"]
