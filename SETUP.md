# AWS Load Balancer Auto Scaling Project - Setup Guide

## 🚀 Quick Start

This project creates a highly available, auto-scaling web application on AWS with the following architecture:

```
Internet → Application Load Balancer → Auto Scaling Group → EC2 Instances (Multi-AZ)
```

### Prerequisites

1. **AWS Account** with appropriate permissions
2. **AWS CLI** installed and configured
3. **Terraform** (version 1.0 or later)

### Installation Commands

```bash
# Install AWS CLI (macOS)
brew install awscli

# Install Terraform (macOS)
brew install terraform

# Configure AWS credentials
aws configure
```

## 📁 Project Structure

```
LB-ASG/
├── README.md                   # Main documentation
├── SETUP.md                   # This setup guide
├── terraform/                 # Infrastructure as Code
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Variable definitions
│   ├── outputs.tf            # Output values
│   └── terraform.tfvars      # Variable values (customize this)
├── app/                      # Web application
│   ├── index.html            # Website page
│   ├── style.css             # Styling
│   └── user-data.sh          # EC2 startup script
└── scripts/
    └── deploy.sh             # Automated deployment script
```

## 🛠️ Configuration

### 1. Customize Variables (Optional)

Edit `terraform/terraform.tfvars` to customize your deployment:

```hcl
# AWS Region
aws_region = "us-east-1"

# Project Name (used as prefix for all resources)
project_name = "my-lb-asg-demo"

# Auto Scaling Configuration
min_size         = 1    # Minimum instances
max_size         = 6    # Maximum instances
desired_capacity = 2    # Initial instances

# Instance Configuration
instance_type = "t3.micro"  # Free tier eligible
```

### 2. Available AWS Regions

Choose from these popular regions:
- `us-east-1` (N. Virginia)
- `us-west-2` (Oregon) 
- `eu-west-1` (Ireland)
- `ap-southeast-2` (Sydney)

## 🚀 Deployment

### Option 1: Automated Deployment (Recommended)

```bash
# Navigate to project directory
cd LB-ASG

# Deploy everything
./scripts/deploy.sh deploy

# Check status
./scripts/deploy.sh status

# Clean up when done
./scripts/deploy.sh destroy
```

### Option 2: Manual Deployment

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Review deployment plan
terraform plan

# Deploy infrastructure
terraform apply

# Get website URL
terraform output website_url
```

## 🌐 Accessing Your Website

After deployment (typically 3-5 minutes), you'll receive:

1. **Load Balancer DNS Name**: `your-alb-xxxx.region.elb.amazonaws.com`
2. **Website URL**: `http://your-alb-xxxx.region.elb.amazonaws.com`

The website will show:
- Real-time server information
- Architecture diagram
- Auto scaling features
- CPU load testing capability

## 📊 Monitoring & Testing

### Auto Scaling Triggers
- **Scale Up**: CPU > 70% for 10 minutes
- **Scale Down**: CPU < 20% for 10 minutes

### Testing Auto Scaling
1. Visit your website
2. Click "Simulate CPU Load" button
3. Wait 10-15 minutes
4. Check AWS Console → EC2 → Auto Scaling Groups
5. Observe new instances being launched

### AWS Console Monitoring
- **CloudWatch**: View metrics and alarms
- **EC2 → Load Balancers**: Monitor load balancer health
- **EC2 → Auto Scaling Groups**: View scaling activities
- **EC2 → Instances**: See individual instance status

## 💰 Cost Estimation

**Estimated monthly costs (us-east-1):**
- 2x t3.micro instances: ~$16/month
- Application Load Balancer: ~$20/month
- Data transfer: ~$2/month
- **Total**: ~$38/month

**Free Tier Benefits:**
- t3.micro instances: 750 hours/month free for first 12 months
- Reduces cost to ~$20/month during free tier period

## 🔧 Customization

### Modify the Website
Edit `app/index.html` and `app/style.css` to customize the website appearance and content.

### Change Instance Type
Update `instance_type` in `terraform/terraform.tfvars`:
```hcl
instance_type = "t3.small"  # For better performance
```

### Adjust Auto Scaling
Modify scaling parameters in `terraform/terraform.tfvars`:
```hcl
min_size         = 2    # Always run 2 instances
max_size         = 10   # Scale up to 10 instances
desired_capacity = 3    # Start with 3 instances
```

### Add HTTPS Support
1. Purchase/import SSL certificate in AWS Certificate Manager
2. Add HTTPS listener to load balancer in `terraform/main.tf`
3. Update security group to allow port 443

## 🛡️ Security Considerations

### Current Security Features
- ✅ VPC with public subnets only (for demo purposes)
- ✅ Security groups restrict traffic appropriately
- ✅ Load balancer distributes traffic securely
- ✅ Auto scaling maintains availability

### Production Recommendations
- 🔒 Add private subnets for database/backend services
- 🔒 Implement AWS WAF for web application firewall
- 🔒 Use AWS Certificate Manager for SSL certificates
- 🔒 Enable CloudTrail for audit logging
- 🔒 Restrict SSH access to specific IP ranges
- 🔒 Use IAM roles instead of access keys
- 🔒 Enable VPC Flow Logs

## 🔍 Troubleshooting

### Common Issues

**Website not loading:**
```bash
# Check if instances are healthy
aws elbv2 describe-target-health --target-group-arn <target-group-arn>

# Check Auto Scaling Group
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names <asg-name>
```

**Instances not scaling:**
```bash
# Check CloudWatch alarms
aws cloudwatch describe-alarms

# View scaling activities
aws autoscaling describe-scaling-activities --auto-scaling-group-name <asg-name>
```

**Deployment fails:**
```bash
# Check Terraform logs
terraform plan -detailed-exitcode

# Validate AWS credentials
aws sts get-caller-identity
```

### Health Check Failures
If health checks are failing:
1. Verify security group allows port 80 from load balancer
2. Check if Apache is running on EC2 instances
3. Ensure user data script completed successfully
4. Review instance system logs in EC2 console

### Auto Scaling Not Working
1. Check CloudWatch alarms are in "OK" state
2. Verify IAM roles have necessary permissions
3. Ensure instances are sending metrics to CloudWatch
4. Check scaling policies are properly configured

## 🧹 Cleanup

### Complete Cleanup
```bash
# Using deployment script (recommended)
./scripts/deploy.sh destroy

# Or manually
cd terraform
terraform destroy
```

### Verify Cleanup
Check AWS Console to ensure all resources are deleted:
- EC2 → Instances
- EC2 → Load Balancers  
- EC2 → Auto Scaling Groups
- VPC → Your VPCs
- CloudWatch → Alarms

## 📚 Learning Resources

- [AWS Auto Scaling Documentation](https://docs.aws.amazon.com/autoscaling/)
- [Application Load Balancer Guide](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Free Tier](https://aws.amazon.com/free/)

## 🆘 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review AWS CloudWatch logs
3. Verify all prerequisites are met
4. Ensure AWS credentials have sufficient permissions

---

**Happy scaling! 🚀**