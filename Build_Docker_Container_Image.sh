#!/bin/bash

docker network create --driver bridge virtual_machines_dockerized_network
docker build --file src/Dockerfile --tag virtual_machines_dockerized src

echo ""
echo "Docker image built."
echo "Closing in 9999 seconds. Press ctrl+c to force close."

sleep 9999
