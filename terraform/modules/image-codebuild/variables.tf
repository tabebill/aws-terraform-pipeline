# Define the GitHub repository URL
variable "github_repo_url" {
  type    = string
  default = "https://github.com/tabebill/random-actor.git"
}

# Define Docker image name
variable "docker_image_name" {
  type    = string
  default = "random-actor"
}

variable "repository_name" {
  description = "Name for the ECR repository"
  type        = string
}

variable "region" {
  description = "ECR region"
  type        = string
}