output "BastionSG" {
  value = aws_security_group.BastionSG.id
}

output "ECSSG" {
  value = aws_security_group.ECSSG.id
}

output "ECSProfile" {
  value = aws_iam_instance_profile.ecs_agent-profile.id
}
output "ecsTaskExecutionRolearn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ALBSG" {
  value = aws_security_group.ALBSG.id
}