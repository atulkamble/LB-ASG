# AWS Region - Change this to your preferred region
aws_region = "us-east-1"

# Project Name - This will be used as a prefix for resource names
project_name = "lb-asg-demo"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"
az_count = 2

# EC2 Configuration
instance_type = "t3.micro"  # Free tier eligible

# Auto Scaling Configuration
min_size         = 1
max_size         = 6
desired_capacity = 2