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