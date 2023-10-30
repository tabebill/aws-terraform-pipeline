output "role_name" {
  value = aws_iam_role.codebuild_service_role.name
}
output "role_id" {
  value = aws_iam_role.codebuild_service_role.id
}
output "role_arn" {
  value = aws_iam_role.codebuild_service_role.arn
}