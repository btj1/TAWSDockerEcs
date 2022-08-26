// Choose latest Amazon2 Linux AMI for x86_64 for Bastion Hosts 

data "aws_ami" "amaz_linux" {
  most_recent      = true
  owners           = ["amazon"]

filter {
    name   = "name"
    values = ["*amzn2-*"]
  }
filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

// Choose latest Amazon2 ECS AMI for ECS Cluster 

data "aws_ami" "ecs_linux" {
  most_recent      = true
  owners           = ["amazon"]

filter {
    name   = "name"
    values = ["*ecs-*"]
  }
filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

// Launch Config && ASG && including IAM Role Definiiton

data "aws_iam_policy_document" "ecs_pol" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
 }

resource "aws_iam_role" "ecsInstancerole" {
  name               = "ecsInstanceRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_pol.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecsInstancerole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent-profile" {
  name = "ecs-agent-profile"
  role = aws_iam_role.ecsInstancerole.name
}

resource "aws_launch_configuration" "ecs_launchconf" {
    image_id             = data.aws_ami.ecs_linux.id
    iam_instance_profile = aws_iam_instance_profile.ecs_agent-profile.name
    security_groups      = [var.ECSSG]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=Koffee-Luv-Cluster >> /etc/ecs/ecs.config;\necho ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;"
    instance_type        = "t2.micro"
    key_name             = var.key_name

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "ecs_asg" {
    name                      = "${var.project_name}-asg"
    vpc_zone_identifier       = [for r in var.AppSubnet_IDs : r]
    launch_configuration      = aws_launch_configuration.ecs_launchconf.name
    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 3
    health_check_grace_period = 300
    health_check_type         = "EC2"
}

//Create Bastion Instances based on PublicSubnets 

resource "aws_instance" "Bastion_Instances" {
  
  for_each = var.PublicSubnet_IDs
    
  ami = data.aws_ami.amaz_linux.id
  instance_type = "t2.micro"
  subnet_id = each.value
  key_name = var.key_name
  vpc_security_group_ids = [var.BastionSG]
  
  tags = {
    Project = "var.project_name" 
    Name = "Bastion_${each.key}"
  }

}





