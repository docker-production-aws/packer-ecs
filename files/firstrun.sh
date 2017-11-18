#!/usr/bin/env bash
set -e

# Configure ECS Agent
echo "ECS_CLUSTER=${ECS_CLUSTER}" > /etc/ecs/ecs.config

# Enable docker host networking mode if DOCKER_NETWORK_MODE is set to "host"
if [ $DOCKER_NETWORK_MODE = "host" ]
then
  sudo sed -i -e "s|^\(OPTIONS=\".*\)\"$|\1 --bridge=none --ip-forward=false --ip-masq=false --iptables=false\"|" \
    /etc/sysconfig/docker
fi

# Stop Docker service
sudo service docker stop

# Remove Docker network database
sudo rm -rf /var/lib/docker/network

# Remove docker0 interface if it has been created
sudo ip link del docker0 || true