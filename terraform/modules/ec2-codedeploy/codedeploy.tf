# Create CodeDeploy role
resource "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"]
}

# Attach CodeDeploy role to deployment group
resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# Define the AWS CodeDeploy Application
resource "aws_codedeploy_app" "my_app" {
  name = "MyCodeDeployApp"
  compute_platform = "Server"
}

# Define the AWS CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "my_deployment_group" {
  app_name = aws_codedeploy_app.my_app.name
  deployment_config_name = var.deployment_config_name
  deployment_group_name = "MyDeploymentGroup"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  service_role_arn = aws_iam_role.codedeploy_role.arn
  trigger_configuration  {
    trigger_events      = ["DeploymentStart", "DeploymentSuccess"]
    trigger_name        = "MyDeploymentTrigger"
    trigger_target_arn  = aws_sns_topic.my_sns_topic.arn
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "DeploymentGroup"
      type  = "KEY_AND_VALUE"
      value = "MyDeploymentGroup"  # Match the ASG tag
    }
  }
}

# SNS Topic
resource "aws_sns_topic" "my_sns_topic" {
  name = "my-sns-topic"
}