output "vpc_id" {
  description = "VPC Id"
  value       = aws_vpc.my_vpc.id
}

output "public_subnet" {
  description = "Will be used by Web Server Module to set subnet_ids"
  value = aws_subnet.public_subnet
}