
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
