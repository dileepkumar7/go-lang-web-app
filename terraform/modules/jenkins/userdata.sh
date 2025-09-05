#!/bin/bash
yum update -y
amazon-linux-extras enable docker
yum install -y docker git
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Jenkins dependencies
yum install -y java-17-amazon-corretto

# Add Jenkins repo and install
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins
systemctl enable jenkins
systemctl start jenkins
usermod -aG docker jenkins

# Install Go
# wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
# rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
# echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
# echo "export PATH=$PATH:/usr/local/go/bin" >> /home/ec2-user/.bashrc
# source /etc/profile
yum install go -y
