output "aws_codedeploy_app_arn" {
  description = "aws_codedeploy_app_arn"
  value       = aws_codedeploy_app.my_app.arn
}

output "aws_codedeploy_deployment_group_arn" {
  description = "aws_codedeploy_deployment_group"
  value       = aws_codedeploy_deployment_group.my_deployment_group.arn
}