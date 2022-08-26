terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.67.0"
    }
      
  }

  backend "s3" {
 //   profile = "tf_deploy"
    bucket  = "tc-remotestate-64357"
    key     = "terraform-aws"
    region  = "us-east-1"

  }

}
provider "aws" {
  region  = var.region
//  profile = "tf_deploy"
  
}

