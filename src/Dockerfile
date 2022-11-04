FROM debian:bullseye-slim AS prepimage

ENV LOOKING_GLASS_VER="B5.0.1"
ENV SCREAM_VER="3.9"
ENV QEMU_VER="7.1.0"
ENV TINI_VERSION="v0.19.0"

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -qq update -y && \
    apt-get install locales -y --no-install-recommends

# Setting up the locales
RUN echo 'en_US ISO-8859-1' >> /etc/locale.gen && \
    echo 'en_US.ISO-8859-15 ISO-8859-15' >> /etc/locale.gen && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
    locale-gen

FROM prepimage AS buildimage

RUN apt-get -qq update -y && \
    apt-get -qq install -y binutils-dev fonts-dejavu-core cmake libfontconfig-dev gcc g++ pkg-config libegl-dev libgl-dev libgles-dev libspice-protocol-dev nettle-dev libx11-dev libxcursor-dev libxi-dev libxinerama-dev libxpresent-dev libxss-dev libxkbcommon-dev libwayland-dev wayland-protocols wget gnupg gcc time ca-certificates python3 ninja-build libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev
    
FROM buildimage AS qemu_buildimage

RUN apt-get -qq install -y libspice-protocol-dev libspice-server-dev libusb-1.0-0-dev libusbredirparser-dev

# Compile the binaries
RUN wget https://download.qemu.org/qemu-${QEMU_VER}.tar.xz && \
    tar xvJf qemu-${QEMU_VER}.tar.xz && \
    mkdir /qemu-${QEMU_VER}/build/ && \
    cd /qemu-${QEMU_VER}/build/ && \
    ../configure --target-list=x86_64-softmmu --enable-kvm --enable-modules --enable-spice --enable-libusb --enable-usb-redir --prefix=/usr && \
    make -j`nproc` install DESTDIR=/tmp/qemu-${QEMU_VER}_builded

# Create the deb package
RUN mkdir -p /tmp/qemu-${QEMU_VER}_builded/DEBIAN && \
    MAINTAINER="$(whoami)"_"$(hostname)" && \ 
    ARCH="$(dpkg --print-architecture)" && \
    echo "Package: qemu\nVersion:${QEMU_VER}\nArchitecture: $ARCH\nMaintainer: $MAINTAINER\nDescription: Custom qemu\nDepends: seabios, ipxe-qemu, libfdt1, libspice-server1\nRecommends: ovmf\nProvides: qemu-kvm, qemu-utils, qemu-system-i386, qemu-system-x86, qemu-system-x86-64" > /tmp/qemu-${QEMU_VER}_builded/DEBIAN/control && \
    cat /tmp/qemu-${QEMU_VER}_builded/DEBIAN/control && \
    dpkg-deb --build --root-owner-group /tmp/qemu-${QEMU_VER}_builded
    
FROM buildimage AS looking_glass_buildimage

# Download looking glass
RUN wget https://looking-glass.io/artifact/${LOOKING_GLASS_VER}/source -O looking-glass-${LOOKING_GLASS_VER}.tar.gz

RUN tar -xvf looking-glass-${LOOKING_GLASS_VER}.tar.gz && \
    cd looking-glass-${LOOKING_GLASS_VER}/client/ && \
    mkdir build && \
    cd build && \
    cmake -j`nproc` ../ && \
    make -j`nproc`
    
FROM buildimage AS scream_buildimage

# Download libasound2-dev to enable output to alsa
RUN apt-get -qq update -y && \
    apt-get -qq install -y libasound2-dev

RUN wget https://github.com/duncanthrax/scream/archive/refs/tags/${SCREAM_VER}.tar.gz -O scream-${SCREAM_VER}.tar.gz

RUN tar -xvf scream-${SCREAM_VER}.tar.gz && \
    cd scream-${SCREAM_VER}/Receivers/unix && \
    mkdir build && \
    cd build && \
    cmake -j`nproc` ../ && \
    make -j`nproc`
    
FROM prepimage AS runimage

# Copy the built qemu binaries to the running image
COPY --from=qemu_buildimage /tmp/qemu-${QEMU_VER}_builded.deb qemu-${QEMU_VER}.deb

# Installing the required packages for the built QEMU
RUN apt-get -qq update -y && \
    apt-get -qq install -y --no-install-recommends seabios ipxe-qemu libfdt1 libspice-server1

# Install binaries
RUN dpkg -i qemu-${QEMU_VER}.deb && \
    rm -rf /qemu-${QEMU_VER}.deb && \
    apt-get -qq install -y --no-install-recommends -o Dpkg::Options::="--force-overwrite" ovmf

# Setting up base operating system
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -qq install -y --no-install-recommends apt-utils gnupg time nano dnsmasq supervisor axel xauth && \
    apt-get -qq install -y libxss1 libxpresent1 libegl1 libgl1
    
# Add Tini init system
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Installing the extra virtualisation packages and pulseaudio for scream
RUN apt-get -qq install -y --no-install-recommends libvirt-daemon libvirt-daemon-system libvirt-clients libguestfs-tools libosinfo-bin bridge-utils virt-manager virtinst ovmf gir1.2-spiceclientgtk-3.0 && \
    apt-get -qq install -y pulseaudio && \
    rm -rf /var/lib/apt/lists

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

