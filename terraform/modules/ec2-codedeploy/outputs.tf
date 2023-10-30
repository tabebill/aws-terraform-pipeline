output "aws_codedeploy_app_arn" {
  description = "aws_codedeploy_app_arn"
  value       = aws_codedeploy_app.my_app.arn
}

output "aws_codedeploy_deployment_group_arn" {
  description = "aws_codedeploy_deployment_group"
  value       = aws_codedeploy_deployment_group.my_deployment_group.arn
}

output "aws_codedeploy_app" {
  description = "aws codedeploy app name"
  value       = aws_codedeploy_app.my_app.name
}

output "aws_codedeploy_deployment_group_name" {
  description = "aws codedeploy group name"
  value       = aws_codedeploy_deployment_group.my_deployment_group.deployment_group_name
}