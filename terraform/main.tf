provider "aws" {
  region = "us-east-1"
}


resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH, HTTP and Jenkins"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Go-App"
    from_port   = 1010
    to_port     = 1010
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-00ca32bbc84273381" # Amazon Linux 2023 (us-east-1)
  instance_type          = "t2.micro"
  key_name               = "n_virginia_jenkins"
  security_groups        = [aws_security_group.jenkins_sg.name]

  user_data = <<-EOF
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
              wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
              rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
              echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile
              echo "export PATH=\$PATH:/usr/local/go/bin" >> /home/ec2-user/.bashrc
              source /etc/profile
              EOF

  tags = {
    Name = "jenkins-server"
  }
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

# output "jenkins_admin_password_command" {
#   value = "ssh -i  ec2-user@${aws_instance.jenkins.public_ip} sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
# }
