variable "project_name" {
  type        = string
  default     = "liveproject_TAWS"
  description = "Name for the live_project"
}
variable "ECSProfile" {
  type        = string
  description = "ECS Instance Profile"
}
variable "ECSSG" {
  type        = string
  description = "Sec Group ECS EC2 Nodes"
}
variable "key_name" {
  type        = string
  description = "KeyName for precreated SSH Key in AWS"
}
variable "AppSubnet_IDs" {
  type        = map(string)
  
  description = "Map of App Subnet IDs"
}



