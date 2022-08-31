// Choose latest Amazon2 ECS AMI for ECS Cluster 

data "aws_ami" "ecs_linux" {
  most_recent      = true
  owners           = ["amazon"]

filter {
    name   = "name"
    values = ["al2022-ami*ecs-*"]
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

## Get AWS Account_ID:

data "aws_caller_identity" "awsaccount" {}

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


## ECS Cluster Resources 

resource "aws_ecs_cluster" "ecs-cluster" {
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
    desired_capacity          = 2
    min_size                  = 1
    max_size                  = 3
    health_check_grace_period = 300
    health_check_type         = "EC2"
}

# ECS Task Definiiton

resource "aws_ecs_task_definition" "task_definition" {
  family             = "${var.project_name}-Website"
  execution_role_arn = var.ecsTaskExecutionRolearn 
  memory             = 128
  
  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-Website"
      image     = "${data.aws_caller_identity.awsaccount.account_id}.dkr.ecr.${var.region}.amazonaws.com/koffeeluvrepo:latest"
      essential = true
      portMappings = [
        {
          
          containerPort = 8000
         
        }
      ]
    }
  ])

  tags = {
      ProjectName = var.project_name
  }

}

# ECS Service

resource "aws_ecs_service" "koffeeluv" {
  name            = "${var.project_name}-Website"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  launch_type     = "EC2"
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = aws_ecs_task_definition.task_definition.family
    container_port   = 8000
  }

}



