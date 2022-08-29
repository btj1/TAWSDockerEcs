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

resource "aws_security_group" "ECSSG" {
  name        = "Allow_ssh_for_bastions_ECS"
  description = "Allow SSH Inbound from Bastion Hosts"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from Bastions"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups=[aws_security_group.BastionSG.id]
    
  }
  
  ingress {
    description      = "HTTP from ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups=[aws_security_group.alb.id]
    
  }
   ingress {
    description      = "Ephemeral from ALB? "
    from_port        = 32768
    to_port          = 65535
    protocol         = "tcp"
    security_groups=[aws_security_group.alb.id]
    
  }

   
   ingress {
    description      = "Containerport "
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    security_groups=[aws_security_group.alb.id]
    
  }

  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }




  tags = {
    Name = "Allow Ingress SSH only from Bastions"
  }
}

resource "aws_security_group" "alb" {
  name   = "${var.project_name}-sg-alb"
  vpc_id = var.vpc_id
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
}