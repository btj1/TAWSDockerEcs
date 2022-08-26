resource "aws_security_group" "BastionSG" {
  name        = "SG for Bastion Hosts"
  description = "Allow SSH Inbound for BastionHosts"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH to Bastions from World"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow SSH to Bastions"
  }
}


resource "aws_security_group" "APPSG" {
  name        = "Allow_ssh_for_bastions"
  description = "Allow SSH Inbound from Bastion Hosts"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from Bastions"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups=[aws_security_group.BastionSG.id]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "Allow Ingress SSH only from Bastions"
  }
}