#!/usr/bin/env bash
set -e

# Additional operating system packages
packages="awslogs"

# Exclude Docker and ECS Agent from update
sudo yum -y -x docker\* -x ecs\* update

echo "### Installing extra packages: $packages ###"
sudo yum -y install $packages 