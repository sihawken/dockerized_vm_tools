#!/bin/bash

docker exec vm chmod 666 /dev/shm/win10-looking-glass
docker exec vm su looking-glass -c "/bin/looking-glass-client -F -f /dev/shm/win10-looking-glass -m 100 input:rawMouse yes"
