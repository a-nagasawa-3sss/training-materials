# application.tf
# Application Infrastructure - IAM Role and EC2 Instance

# IAM Role
resource "aws_iam_role" "server_role" {
  name = "ec2-tf-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "server_role_ec2_instance_connect" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
  role       = aws_iam_role.server_role.name
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "server_profile" {
  name = "ec2-tf-instance-profile"
  path = "/"
  role = aws_iam_role.server_role.name
}

# Amazon Linux 2023 AMI from SSM Parameter Store
data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# EC2 Instance
resource "aws_instance" "instance" {
  ami                         = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.server_profile.name
  associate_public_ip_address = true
  
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # user_data
  user_data = <<-EOF
    #!/bin/bash
    sudo dnf update -y
    sudo dnf install -y nginx mysql ncurses-compat-libs
    sudo systemctl enable --now nginx
  EOF

  tags = {
    Name = "ec2-tf-instance"
  }
}