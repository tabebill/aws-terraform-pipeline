variable "region" {
  description = "ECR region"
  type        = string
}

variable "codebuild_role_arn" {
  type        = string
  description = "Name of the IAM role for CodeBuild"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

variable "github_repo_url" {
  type    = string
  default = "https://github.com/tabebill/aws-terraform-pipeline.git"
}

variable "tfstate_bucket" {
  type        = string
  description = "tfstate bucket which would have an artifacts prefix for artifacts"
}