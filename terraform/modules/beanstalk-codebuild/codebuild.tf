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
      value = var.aws_default_region
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
