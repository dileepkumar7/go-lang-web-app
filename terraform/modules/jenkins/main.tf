resource "aws_security_group" "this" {
    name = var.sg_name
    description = var.sg_description
    vpc_id = var.vpc_id
    dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port=ingress.value.port
      to_port = ingress.value.port
      protocol = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }

}

egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.egress_cidr_blocks
}
tags = var.tags
}
resource "aws_instance" "jenkins" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
   security_groups = [aws_security_group.this.name ]
     user_data      = file("${path.module}/userdata.sh")

   tags = merge(var.tags,{
    name="Jenkins-Server"
   })
  
}

