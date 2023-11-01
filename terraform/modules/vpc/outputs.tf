output "vpc_id" {
  description = "VPC Id"
  value       = aws_vpc.my_vpc.id
}

output "public_subnet1" {
  description = "Will be used by Web Server Module to set subnet_ids"
  value = aws_subnet.public_subnet1.id
}

output "public_subnet2" {
  description = "Will be used by Web Server Module to set subnet_ids"
  value = aws_subnet.public_subnet2.id
}

output "my_asg_arn" {
  description = "Auto-Scaling Group ARN"
  value       = aws_autoscaling_group.my_asg.arn
}