# variables.tf
# Variable definitions

variable "aws_region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region"
}

variable "availability_zone_1" {
  type        = string
  default     = "ap-northeast-1a"
  description = "Availability Zone 1"
}

variable "availability_zone_2" {
  type        = string
  default     = "ap-northeast-1c"
  description = "Availability Zone 2"
}

variable "db_username" {
  type        = string
  default     = "admin"
  description = "Database master username"
}

variable "db_password" {
  type        = string
  default     = "password"
  description = "Database master password"
  sensitive   = true
}