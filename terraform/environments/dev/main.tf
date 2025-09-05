data "aws_vpc" "default" {
  default = true
}


module "jenkins" {
  source = "../../modules/jenkins"

  ami_id        = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  key_name      = "n_virginia_jenkins"
#   vpc_id        = var.vpc_id
vpc_id = data.aws_vpc.default.id

  ingress_rules = [
    { description = "SSH",     port = 22,   cidr_blocks = var.allowed_cidrs },
    { description = "HTTP",    port = 80,   cidr_blocks = var.allowed_cidrs },
    { description = "Jenkins", port = 8080, cidr_blocks = var.allowed_cidrs },
    { description = "Go-App",  port = 1010, cidr_blocks = var.allowed_cidrs },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = "dev"
    Project     = "jenkins"
    Owner       = "DevOps"
    Name ="Jenkins-Server"
  }
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}
