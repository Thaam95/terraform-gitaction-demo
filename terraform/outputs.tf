output "vpc_id" {
  description = "Created VPC ID."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Created public subnet IDs."
  value       = { for name, subnet in aws_subnet.public : name => subnet.id }
}

output "private_subnet_ids" {
  description = "Created private subnet IDs."
  value       = { for name, subnet in aws_subnet.private : name => subnet.id }
}

output "security_group_id" {
  description = "Demo security group ID."
  value       = aws_security_group.demo.id
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private route table ID."
  value       = aws_route_table.private.id
}
