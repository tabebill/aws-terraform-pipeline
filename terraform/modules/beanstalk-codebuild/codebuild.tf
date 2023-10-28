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

resource "aws_codebuild_project" "my_codebuild_project2" {
  name = "my-codebuild-project2"
  description = "My Beanstalk CodeBuild Project"
  service_role = aws_iam_role.codebuild_service_role.arn
  source {
    type = "CODEPIPELINE"  # Use CODEPIPELINE source
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:5.0"
    type = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "LOCAL"  # or "S3"
  }

  build_timeout = "30"
}
