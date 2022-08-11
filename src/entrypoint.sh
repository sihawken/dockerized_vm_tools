#!bin/bash

# This is used by "virsh console" to create lock files.  Technically,
# "virsh console" uses /var/lock, but that is a symlink to /run/lock.
mkdir -p /run/lock

# Set the display cookie
xauth add $DISPLAY . $XAUTH_COOKIE

# Make sure permissions on /dev/kvm are correct.
if [ -c /dev/kvm ]; then
	chown root:root /dev/kvm && chmod 666 /dev/kvm
else
	echo "*** no /dev/kvm"
fi

exec "$@"
