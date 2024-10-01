#!/bin/bash
# Update the system
apt-get update
apt-get upgrade -y

cd /tmp

# Install SSM Agent
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
dpkg -i amazon-ssm-agent.deb
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Install necessary packages
apt-get install -y wget unzip

# Set up SSH configuration for jumpstation
echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config
echo "GatewayPorts yes" >> /etc/ssh/sshd_config
systemctl restart ssh

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Additional jumpstation setup can be added here


sudo apt-get -y install wget curl vim openssl git
git clone --depth 1 \
  https://github.com/kelseyhightower/kubernetes-the-hard-way.git


cd kubernetes-the-hard-way
mkdir downloads
wget -q --show-progress \
  --https-only \
  --timestamping \
  -P downloads \
  -i downloads.txt


chmod +x downloads/kubectl
cp downloads/kubectl /usr/local/bin/

kubectl version --client

