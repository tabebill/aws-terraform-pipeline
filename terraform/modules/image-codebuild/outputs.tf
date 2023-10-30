output "codebuild_project1" {
  value       = aws_codebuild_project.my_codebuild_project.name
  description = "aws codebuild project name"
}