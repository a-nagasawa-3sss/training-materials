# network.tf
# Network Infrastructure - VPC, Subnets, RouteTable, InternetGateway, SecurityGroups

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-vpc"
  }
}

# Subnets
resource "aws_subnet" "public_subnet_1" {
  availability_zone = var.availability_zone_1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "tf-public-subnet1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  availability_zone = var.availability_zone_2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "tf-public-subnet2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  availability_zone = var.availability_zone_1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"

  tags = {
    Name = "tf-private-subnet1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  availability_zone = var.availability_zone_2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"

  tags = {
    Name = "tf-private-subnet2"
  }
}

# Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "tf-public-rtb"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "tf-private-rtb"
  }
}

# Subnet Route Table Associations
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  tags = {
    Name = "tf-igw"
  }
}

resource "aws_internet_gateway_attachment" "internet_gateway_attachment" {
  internet_gateway_id = aws_internet_gateway.internet_gateway.id
  vpc_id              = aws_vpc.vpc.id
}

resource "aws_route" "internet_gateway_to_route_table" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
  route_table_id         = aws_route_table.public_route_table.id
}

# Security Groups
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-tf-sg"
  description = "ec2-tf-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "ec2-tf-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-tf-sg"
  description = "db-tf-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "db-tf-sg"
  }
}

# Security Group Rules
resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress_http" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress_ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "3.112.23.0/29"
}

resource "aws_vpc_security_group_egress_rule" "ec2_sg_egress_all" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "-1"  # すべてのプロトコル
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "db_sg_ingress_mysql" {
  security_group_id            = aws_security_group.db_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.ec2_sg.id
}