terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = local.tfstate_bucket
}

module "my_vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = local.vpc_cidr
  availability_zones  = local.availability_zones
  public_subnet_cidrs = local.public_subnet_cidrs
}

module "docker_image_codebuild" {
  source             = "./modules/image-codebuild"
  aws_ecr_repository = local.aws_ecr_repository
  codebuild_role_arn = aws_iam_role.codebuild_service_role.arn
  region             = local.region
  github_repo_url    = local.github_repo_url
  docker_image_name  = local.docker_image_name
  tfstate_bucket     = local.tfstate_bucket
}

module "beanstalk_app_build" {
  source             = "./modules/beanstalk-codebuild"
  region             = local.region
  account_id         = local.account_id
  codebuild_role_arn = aws_iam_role.codebuild_service_role.arn
  tfstate_bucket     = local.tfstate_bucket
}

module "codepipeline" {
  source                               = "./modules/codepipeline"
  codebuild_project1                   = module.docker_image_codebuild.codebuild_project1
  codebuild_project2                   = module.beanstalk_app_build.codebuild_project2
  aws_codedeploy_app                   = module.ec2-codedeploy.aws_codedeploy_app
  aws_codedeploy_deployment_group_name = module.ec2-codedeploy.aws_codedeploy_deployment_group_name
  tfstate_bucket                       = module.tf-state.tfstate_bucket
  aws_codestarconnections_connection   = local.aws_codestarconnections_connection
}

module "ec2-codedeploy" {
  source              = "./modules/ec2-codedeploy"
  region              = local.region
  vpc_cidr            = local.vpc_cidr
  availability_zones  = local.availability_zones
  public_subnet_cidrs = local.public_subnet_cidrs
  my_asg_arn          = module.my_vpc.my_asg_arn
}


resource "aws_iam_role" "codebuild_service_role" {
  name               = "codebuild_service_role"
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