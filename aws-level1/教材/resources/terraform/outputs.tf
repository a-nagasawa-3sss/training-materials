# outputs.tf
# All output definitions

# Network Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.public_subnet_2.id
}

output "private_subnet_1_id" {
  description = "Private Subnet 1 ID"
  value       = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  description = "Private Subnet 2 ID"
  value       = aws_subnet.private_subnet_2.id
}

output "ec2_sg_id" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2_sg.id
}

output "db_sg_id" {
  description = "DB Security Group ID"
  value       = aws_security_group.db_sg.id
}

# Application Outputs
output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.instance.id
}

output "instance_public_ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.instance.public_ip
}

# Database Outputs
output "rds_instance_id" {
  description = "RDS Instance ID"
  value       = aws_db_instance.rds_instance.id
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}