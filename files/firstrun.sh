#!/usr/bin/env bash
set -e

# Configure ECS Agent
echo "ECS_CLUSTER=${ECS_CLUSTER}" > /etc/ecs/ecs.config

# Set HTTP Proxy URL if provided
if [ -n $PROXY_URL ]
then
  echo export HTTPS_PROXY=$PROXY_URL >> /etc/sysconfig/docker
  echo HTTPS_PROXY=$PROXY_URL >> /etc/ecs/ecs.config
  echo NO_PROXY=169.254.169.254,169.254.170.2,/var/run/docker.sock >> /etc/ecs/ecs.config
  echo HTTP_PROXY=$PROXY_URL >> /etc/awslogs/proxy.conf
  echo HTTPS_PROXY=$PROXY_URL >> /etc/awslogs/proxy.conf
  echo NO_PROXY=169.254.169.254 >> /etc/awslogs/proxy.conf
fi

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

# Write AWS Logs region
sudo tee /etc/awslogs/awscli.conf << EOF > /dev/null
[plugins]
cwlogs = cwlogs
[default]
region = ${AWS_DEFAULT_REGION}
EOF

# Write AWS Logs config
sudo tee /etc/awslogs/awslogs.conf << EOF > /dev/null
[general]
state_file = /var/lib/awslogs/agent-state    
 
[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = ${STACK_NAME}/ec2/${AUTOSCALING_GROUP}/var/log/dmesg
log_stream_name = {instance_id}

[/var/log/messages]
file = /var/log/messages
log_group_name = ${STACK_NAME}/ec2/${AUTOSCALING_GROUP}/var/log/messages
log_stream_name = {instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/docker]
file = /var/log/docker
log_group_name = ${STACK_NAME}/ec2/${AUTOSCALING_GROUP}/var/log/docker
log_stream_name = {instance_id}
datetime_format = %Y-%m-%dT%H:%M:%S.%f

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log*
log_group_name = ${STACK_NAME}/ec2/${AUTOSCALING_GROUP}/var/log/ecs/ecs-init
log_stream_name = {instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ
time_zone = UTC

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log*
log_group_name = ${STACK_NAME}/ec2/${AUTOSCALING_GROUP}/var/log/ecs/ecs-agent
log_stream_name = {instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ
time_zone = UTC
EOF

# Start services
sudo service awslogs start