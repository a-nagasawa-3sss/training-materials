# database.tf
# Database Infrastructure - RDS Subnet Group and RDS Instance

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "tf-db-subnetgroup"
  description = "tf-db-subnetgroup"
  
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "tf-db-subnetgroup"
  }
}

# RDS Instance
resource "aws_db_instance" "rds_instance" {
  identifier     = "tf-rds"
  engine         = "mysql"
  engine_version = "8.0.41"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  storage_type      = "gp2"
  
  db_name  = "RDS"
  username = var.db_username
  password = var.db_password
  
  publicly_accessible    = false
  multi_az              = false
  auto_minor_version_upgrade = false
  
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  
  deletion_protection       = false
  delete_automated_backups = true
  copy_tags_to_snapshot    = false
  backup_retention_period  = 0
  
  skip_final_snapshot = true

  tags = {
    Name = "tf-rds"
  }
}