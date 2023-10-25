resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild_service_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_service_role_policy_attachment" {
  role = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/CodeBuildServiceRolePolicy"
}

resource "aws_ecr_repository" "my_ecr_repo" {
  name = var.repository_name
}
output "ecr_repository_uri" {
  description = "URI of the ECR repository"
  value       = aws_ecr_repository.my_ecr_repo.repository_url
}

resource "aws_codebuild_project" "my_codebuild_project" {
  name = "my-codebuild-project"
  service_role = aws_iam_role.codebuild_service_role.arn

  source {
    type = "GITHUB"
    location = var.github_repo_url
  }

  artifacts {
    type = "CODEPIPELINE"
    name = var.docker_image_name
    path = "${var.docker_image_name}:latest"
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
