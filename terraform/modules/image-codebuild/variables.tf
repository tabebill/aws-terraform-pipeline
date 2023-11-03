# Define the GitHub repository URL
variable "github_repo_url" {
  type    = string
  default = "https://github.com/tabebill/aws-terraform-pipeline.git"
}

# Define Docker image name
variable "docker_image_name" {
  type    = string
  default = "random-actor"
}

variable "aws_ecr_repository" {
  description = "Name for the ECR repository"
  type        = string
}

variable "region" {
  description = "ECR region"
  type        = string
}

variable "codebuild_role_arn" {
  type        = string
  description = "Name of the IAM role for CodeBuild"
}

variable "tfstate_bucket" {
  type        = string
  description = "tfstate bucket which would have an artifacts prefix for artifacts"
}