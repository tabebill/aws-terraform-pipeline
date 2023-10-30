resource "aws_codebuild_project" "my_codebuild_project2" {
  name = "my-codebuild-project2"
  description = "My Beanstalk CodeBuild Project"
  service_role = var.codebuild_role_arn
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
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "LOCAL"  # or "S3"
    modes = ["LOCAL_SOURCE_CACHE"]  # Specify one or more cache modes
  }

  build_timeout = "30"
}
