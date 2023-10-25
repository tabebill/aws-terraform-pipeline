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
  bucket_name = "my-terraform-state-bucket-dchg4357-2"
}

module "my_vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = local.vpc_cidr
  availability_zones  = local.availability_zones
  public_subnet_cidrs = local.public_subnet_cidrs
}

module "docker_image_codebuild" {
  source            = "./modules/image-codebuild"
  repository_name   = "my_ecr_repo"
  region            = local.region
  github_repo_url   = local.github_repo_url
  docker_image_name = local.docker_image_name
}