output "vpc_id" {
  value       = aws_vpc.mainvpc.id
  description = "Stack VPC ID"
}

output "AppSubnet_IDs" {
  value = tomap({
    for k, subnet in aws_subnet.appsubnets : k => subnet.id
  })
  description = "Map of App Subnet IDs"
}

output "PublicSubnet_IDs" {
  value = tomap({
    for k, subnet in aws_subnet.publicsubnets : k => subnet.id
  })
  description = "Map of Public Subnet IDs"
}
