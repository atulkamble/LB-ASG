# AWS Region
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# Project Name
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "lb-asg-demo"
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Number of Availability Zones
variable "az_count" {
  description = "Number of AZs to use"
  type        = number
  default     = 2
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Auto Scaling Group - Minimum Size
variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

# Auto Scaling Group - Maximum Size
variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 6
}

# Auto Scaling Group - Desired Capacity
variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}