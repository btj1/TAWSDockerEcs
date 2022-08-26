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

## Create The ECR Private Repo and a Policy 

resource "aws_ecr_repository" "koffeeluvrepo" {
  name                 = "${var.project_name}repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

 tags = {
    Project = "var.project_name" 
    
 }
}

resource "aws_ecr_repository_policy" "koffeeluv-repo-policy" {
  repository = aws_ecr_repository.koffeeluvrepo.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the Koffeeluv repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}


## ECS Cluster REsources 

resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "Koffee-Luv-Cluster"
  
  tags = {
    Name        = "Koffee-Luv-Cluster"
  }
}

// Launch Config && ASG && including IAM Role Definiiton


resource "aws_launch_configuration" "ecs_launchconf" {
    image_id             = data.aws_ami.ecs_linux.id
    iam_instance_profile = var.ECSProfile
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


