resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "codepipeline_policy_doc" {
  statement {
    sid       = ""
    actions   = ["cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    sid       = ""
    actions   = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "codepipeline_policy"
  path        = "/"
  description = "CodePipeline policy"
  policy      = data.aws_iam_policy_document.codepipeline_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn = aws_iam_policy.codepipeline_policy.arn
  role       = aws_iam_role.codepipeline_role.id
}

resource "aws_codepipeline" "my_pipeline" {
  name     = "my-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = CODEPIPELINE
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        OutputArtifacts = ["source_output"]
      }
    }
  }

  stage {
    name = "Apply" #"Plan"
    action {
      name            = "Build"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.my_codebuild_project.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.my_codebuild_project2.name
      }
    }
  }

  stage {
    name = "Approve"

    action {
      name            = "Approval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      version         = "1"
      input_artifacts = ["build_output"]
      configuration = {
        #NotificationArn = var.approve_sns_arn
        #CustomData = var.approve_comment
        #ExternalEntityLink = var.approve_url
      }
    }
  }

  stage {
    name = "Deploy"
    action {
          name            = "DeployAction"
          category        = "Deploy"
          owner           = "AWS"
          provider        = "CodeDeploy"
          input_artifacts = ["build_output"]

          configuration = {
            ApplicationName          = aws_codedeploy_application.my_app.name
            DeploymentGroupName      = aws_codedeploy_deployment_group.my_deployment_group.name
          }
      }
  }

}