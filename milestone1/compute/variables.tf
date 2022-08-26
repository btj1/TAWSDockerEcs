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

variable "AppSubnet_IDs" {
  type        = map(string)
  
  description = "Map of App Subnet IDs"
}

variable "PublicSubnet_IDs" {
  type        = map(string)
  
  description = "Map of Public Subnet IDs"
}

variable "key_name" {
  type        = string
  description = "KeyName for precreated SSH Key in AWS"
}
variable "BastionSG" {
  type        = string
  description = "Sec Group Bastions Hosts"
}
variable "AppSG" {
  type        = string
  description = "Sec Group App Servers"
}










