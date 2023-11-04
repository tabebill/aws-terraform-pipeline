resource "aws_codebuild_project" "my_codebuild_project" {
  name = "my-codebuild-project"
  description = "My Docker image build CodeBuild Project"
  service_role = var.codebuild_role_arn

  source {
    type      = "GITHUB"
    location  = var.github_repo_url
    buildspec = "terraform/modules/image-codebuild/buildspec.yml"
  }
  source_version = "cicd"

  artifacts {
    type = "NO_ARTIFACTS"
    #artifacts_override {
    #  type = "S3"
    # location = "${var.tfstat_bucket}/artifacts"
    #}
  }

  environment {
    type = "LINUX_CONTAINER"
    image = "aws/codebuild/standard:5.0"
    compute_type = "BUILD_GENERAL1_SMALL"
    environment_variable {
      name  = "ECR_REPO_URI"
      value = aws_ecr_repository.my_ecr_repo.repository_url
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = var.docker_image_name
    }
  }
}

# ECR repository
resource "aws_ecr_repository" "my_ecr_repo" {
    name = var.aws_ecr_repository
}
output "ecr_repository_uri" {
    value = aws_ecr_repository.my_ecr_repo.repository_url
}