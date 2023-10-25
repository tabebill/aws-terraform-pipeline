locals {
  region               = "us-east-1"
  availability_zones   = ["us-east-1a", "us-east-1b"]

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  github_repo_url      = "https://github.com/tabebill/random-actor.git"
  docker_image_name    = "random-actor"
}