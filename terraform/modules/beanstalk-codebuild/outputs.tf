output "codebuild_project2" {
  value       = aws_codebuild_project.my_codebuild_project2.name
  description = "aws codebuild project name"
}