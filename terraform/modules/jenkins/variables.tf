variable "ami_id" {
    description = "AMI ID for EC2 Instance"
    type = string
  
}
variable "instance_type" {
    description = "Instance_type for EC2 Instance"
    type = string
  
}
variable "key_name" {
    description = "SSH Key Name"
    type = string
  
}
variable "sg_name" {
    description = "Security Group Name "
    default = ""

}
variable "sg_description" {
   default = "Allow SSH,HTTP,HTTPS,Jenkins,Go-App"
  
}
variable "vpc_id" {
    description = "VPC id to Deploy Resources into"
    type = string
}
variable "ingress_rules" {
    description = "List of ingress rules"
    type = list(object({
      description =string
      port=number
      cidr_blocks=list(string) 
    }))
  
}
variable "egress_cidr_blocks" {
    type = list(string)
    default =["0.0.0.0/0"]

}

variable "tags" {
    type = map(string)
    default = {
    }
  
}