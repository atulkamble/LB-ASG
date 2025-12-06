#!/bin/bash

# AWS Load Balancer Auto Scaling Project Deployment Script
# This script automates the deployment of the AWS infrastructure

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if AWS CLI is installed
    if ! command_exists aws; then
        print_error "AWS CLI is not installed. Please install it first."
        echo "Installation guide: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
        exit 1
    fi
    
    # Check if Terraform is installed
    if ! command_exists terraform; then
        print_error "Terraform is not installed. Please install it first."
        echo "Installation guide: https://learn.hashicorp.com/tutorials/terraform/install-cli"
        exit 1
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity >/dev/null 2>&1; then
        print_error "AWS credentials are not configured. Please run 'aws configure' first."
        exit 1
    fi
    
    print_success "All prerequisites are met!"
}

# Function to deploy infrastructure
deploy_infrastructure() {
    print_status "Starting infrastructure deployment..."
    
    # Navigate to terraform directory
    cd terraform
    
    # Initialize Terraform
    print_status "Initializing Terraform..."
    terraform init
    
    # Validate Terraform configuration
    print_status "Validating Terraform configuration..."
    terraform validate
    
    # Plan deployment
    print_status "Creating deployment plan..."
    terraform plan -out=tfplan
    
    # Ask for confirmation
    echo
    print_warning "This will create AWS resources that may incur charges."
    read -p "Do you want to proceed with the deployment? (yes/no): " confirmation
    
    if [[ $confirmation != "yes" ]]; then
        print_warning "Deployment cancelled by user."
        exit 0
    fi
    
    # Apply deployment
    print_status "Applying Terraform configuration..."
    terraform apply tfplan
    
    # Get outputs
    print_status "Getting deployment outputs..."
    LOAD_BALANCER_DNS=$(terraform output -raw load_balancer_dns)
    WEBSITE_URL=$(terraform output -raw website_url)
    
    # Navigate back to root directory
    cd ..
    
    print_success "Infrastructure deployed successfully!"
    echo
    print_success "🌐 Your website is available at: $WEBSITE_URL"
    print_success "🔗 Load Balancer DNS: $LOAD_BALANCER_DNS"
    echo
    print_warning "⏰ It may take a few minutes for the instances to be ready and health checks to pass."
}

# Function to check deployment status
check_deployment_status() {
    print_status "Checking deployment status..."
    
    cd terraform
    
    # Get load balancer DNS
    LOAD_BALANCER_DNS=$(terraform output -raw load_balancer_dns 2>/dev/null || echo "")
    
    if [[ -n "$LOAD_BALANCER_DNS" ]]; then
        print_status "Testing website availability..."
        
        # Test website availability
        for i in {1..5}; do
            if curl -s -o /dev/null -w "%{http_code}" "http://$LOAD_BALANCER_DNS" | grep -q "200"; then
                print_success "Website is responding correctly!"
                break
            else
                print_warning "Attempt $i: Website not ready yet, waiting 30 seconds..."
                sleep 30
            fi
            
            if [[ $i -eq 5 ]]; then
                print_warning "Website is not responding yet. This is normal for new deployments."
                print_warning "Please wait a few more minutes and try accessing: http://$LOAD_BALANCER_DNS"
            fi
        done
    else
        print_error "Could not retrieve load balancer DNS. Make sure the infrastructure is deployed."
    fi
    
    cd ..
}

# Function to destroy infrastructure
destroy_infrastructure() {
    print_warning "⚠️  This will DESTROY all AWS resources created by this project!"
    print_warning "This action cannot be undone."
    echo
    read -p "Are you sure you want to destroy the infrastructure? (yes/no): " confirmation
    
    if [[ $confirmation != "yes" ]]; then
        print_warning "Destruction cancelled by user."
        exit 0
    fi
    
    print_status "Destroying infrastructure..."
    
    cd terraform
    terraform destroy -auto-approve
    cd ..
    
    print_success "Infrastructure destroyed successfully!"
}

# Function to show usage
show_usage() {
    echo "AWS Load Balancer Auto Scaling Project Deployment Script"
    echo
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  deploy    Deploy the AWS infrastructure"
    echo "  status    Check deployment status"
    echo "  destroy   Destroy the AWS infrastructure"
    echo "  help      Show this help message"
    echo
    echo "Examples:"
    echo "  $0 deploy     # Deploy the infrastructure"
    echo "  $0 status     # Check if website is running"
    echo "  $0 destroy    # Clean up all resources"
}

# Main script logic
main() {
    echo "======================================"
    echo "AWS Load Balancer Auto Scaling Project"
    echo "======================================"
    echo
    
    case "${1:-}" in
        deploy)
            check_prerequisites
            deploy_infrastructure
            echo
            print_status "Waiting for instances to be ready..."
            sleep 60
            check_deployment_status
            ;;
        status)
            check_deployment_status
            ;;
        destroy)
            destroy_infrastructure
            ;;
        help|--help|-h)
            show_usage
            ;;
        "")
            show_usage
            echo
            print_warning "No option specified. Use 'deploy' to start deployment."
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"