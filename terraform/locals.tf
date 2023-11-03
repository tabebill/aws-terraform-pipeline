locals {
  region             = "us-east-1"
  availability_zones = ["us-east-1a", "us-east-1b"]

  vpc_cidr                           = "10.0.0.0/16"
  public_subnet_cidrs                = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs               = ["10.0.3.0/24", "10.0.4.0/24"]
  github_repo_url                    = "https://github.com/tabebill/aws-terraform-pipeline.git"
  aws_ecr_repository                 = "my_ecr_repo"
  docker_image_name                  = "random-actor"
  account_id                         = "292672040235"
  tfstate_bucket                     = "my-terraform-state-bucket-dchg4357-2"
  aws_codestarconnections_connection = "arn:aws:codestar-connections:us-east-1:292672040235:connection/17809639-0ff9-4bc2-9092-25f93fd0eb69" # this could be created before or after applying terraform, if before you would have to create the resource in the console, and link to github directly, then getting this arn. If after, you would have had to create the resource for it then reference its arn in the codepipeline source stage. 
}