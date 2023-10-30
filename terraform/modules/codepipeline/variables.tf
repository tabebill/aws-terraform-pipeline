variable "codebuild_project1" {
    type    = string
    description = "Name of the image-build codebuild project"
}

variable "codebuild_project2" {
    type    = string
    description = "Name of the beanstalk codebuild project"
}

variable "aws_codedeploy_app" {
    type        = string
    description = "Name of the codedeploy app"
}

variable "aws_codedeploy_deployment_group_name" {
    type        = string
    description = "Name of the codedeploy deployment group name"
}

variable "tfstate_bucket" {
    type        = string
    description = "name of the tfstate bucket which is also the codepipeline artifact store"
}