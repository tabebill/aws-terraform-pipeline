variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs for Subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for Public Subnets"
  type        = list(string)
}

variable "region" {
  description = "Default region"
  type        = string
}

variable "my_asg_arn" {
  description = "auto-scaling group arn"
  type        = string
}

variable "deployment_config_name" {
  description = "deployment_config_name"
  type        = string
  default     = "CodeDeployDefault.AllAtOnce"
}