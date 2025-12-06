# AWS Public Load Balancer Auto Scaling Project

This project demonstrates a scalable web application deployed on AWS using an Application Load Balancer (ALB) and Auto Scaling Group (ASG).

## Architecture Overview

- **Application Load Balancer (ALB)**: Distributes incoming traffic across multiple EC2 instances
- **Auto Scaling Group (ASG)**: Automatically scales EC2 instances based on demand
- **EC2 Instances**: Host the web application
- **VPC**: Provides network isolation and security
- **Security Groups**: Control network access
- **Launch Template**: Defines EC2 instance configuration

## Project Structure

```
LB-ASG/
├── terraform/              # Infrastructure as Code
│   ├── main.tf             # Main Terraform configuration
│   ├── variables.tf        # Variable definitions
│   ├── outputs.tf          # Output values
│   └── terraform.tfvars    # Variable values
├── app/                    # Web application code
│   ├── index.html          # Main website page
│   ├── style.css           # Styling
│   └── user-data.sh        # EC2 startup script
├── scripts/                # Deployment scripts
│   └── deploy.sh           # Deployment automation
└── README.md               # This file
```

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform installed (version 1.0+)
3. An AWS account with necessary permissions

## Quick Start

1. Clone this repository
2. Navigate to the terraform directory
3. Initialize Terraform: `terraform init`
4. Plan deployment: `terraform plan`
5. Deploy infrastructure: `terraform apply`
6. Access your website via the Load Balancer DNS name

## Features

- **High Availability**: Multi-AZ deployment
- **Auto Scaling**: Scales based on CPU utilization
- **Load Balancing**: Even traffic distribution
- **Security**: Proper security group configurations
- **Monitoring**: CloudWatch integration
- **Cost Optimized**: Uses appropriate instance types

## Cleanup

To avoid ongoing charges, destroy the infrastructure when done:
```bash
terraform destroy
```

## Customization

- Modify `terraform/variables.tf` to change instance types, scaling policies, etc.
- Update `app/index.html` to customize the website content
- Adjust security groups in `terraform/main.tf` for different access requirements