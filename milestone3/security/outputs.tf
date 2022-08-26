output "AppSG" {
  value = aws_security_group.APPSG.id
}

output "BastionSG" {
  value = aws_security_group.BastionSG.id
}

output "ECSSG" {
  value = aws_security_group.ECSSG.id
}
