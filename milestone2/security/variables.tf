variable "project_name" {
  type        = string
  default     = "liveproject_TAWS"
  description = "Name for the live_project"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region to deploy the Stack in"
}

variable "vpc_id" {
  type        = string
  description = "VPC_ID"
}