# Terragrunt AWS Infrastructure

This repository contains Terragrunt configurations for managing AWS infrastructure across multiple environments (dev and prod).

## Architecture Overview

The infrastructure includes:

- **VPC**: Multi-AZ VPC with public and private subnets
- **EKS Cluster**: Kubernetes 1.28 with ARM64 (Graviton) node groups
- **Bastion Host**: Secure SSH access point with SSM support
- **S3 Buckets**: Separate buckets for static content and user uploads
- **CloudFront**: CDN distribution for static content delivery
- **Route53**: DNS management with custom records

## Directory Structure

```
terragrunt/
├── terragrunt.hcl              # Root configuration with S3 backend
├── modules/                    # Reusable Terraform modules
│   ├── vpc/
│   ├── eks/
│   ├── bastion/
│   ├── s3/
│   ├── cloudfront/
│   └── route53/
├── dev/                        # Development environment
│   ├── terragrunt.hcl
│   ├── vpc/
│   ├── eks/
│   ├── bastion/
│   ├── s3/
│   ├── cloudfront/
│   └── route53/
└── prod/                       # Production environment
    ├── terragrunt.hcl
    ├── vpc/
    ├── eks/
    ├── bastion/
    ├── s3/
    ├── cloudfront/
    └── route53/
```

## Prerequisites

1. **AWS CLI**: Configure with appropriate credentials
   ```bash
   aws configure
   ```

2. **Terraform**: Version >= 1.5
   ```bash
   terraform version
   ```

3. **Terragrunt**: Latest version
   ```bash
   terragrunt --version
   ```

4. **Environment Variables**: Set your AWS account ID
   ```bash
   export AWS_ACCOUNT_ID="123456789012"
   ```

## Configuration

### Update Root Configuration

Edit `terragrunt.hcl` to set:
- AWS region
- Account ID
- Backend bucket name

### Update Environment Variables

For each environment (dev/prod):

1. **VPC CIDR**: Update `vpc_cidr` in `{env}/vpc/terragrunt.hcl`
2. **Domain Names**: Update domain names in `{env}/route53/terragrunt.hcl`
3. **SSH Access**: Add your SSH public key in `{env}/bastion/terragrunt.hcl`
4. **IP Restrictions**: Configure `allowed_cidr_blocks` for bastion access

## Deployment

### Initialize Backend

First deployment creates the S3 bucket and DynamoDB table automatically:

```bash
cd dev/vpc
terragrunt init
```

### Deploy Full Environment

Deploy all resources in dependency order:

```bash
# Deploy VPC first
cd dev/vpc
terragrunt apply

# Deploy EKS cluster
cd ../eks
terragrunt apply

# Deploy remaining resources
cd ../bastion && terragrunt apply
cd ../s3 && terragrunt apply
cd ../cloudfront && terragrunt apply
cd ../route53 && terragrunt apply
```

### Deploy All Resources at Once

Use `run-all` to deploy everything:

```bash
cd dev
terragrunt run-all apply
```

## Infrastructure Details

### VPC Module

- Creates VPC with configurable CIDR
- 3 public and 3 private subnets across AZs
- NAT gateways (single for dev, multi-AZ for prod)
- Internet gateway and route tables
- Tagged for EKS integration

### EKS Module

- Kubernetes version 1.28
- ARM64 (Graviton) node groups
- OIDC provider for IRSA
- Essential add-ons (VPC CNI, CoreDNS, kube-proxy)
- CloudWatch logging
- Environment-specific scaling

**Dev Configuration:**
- SPOT instances
- 2 min, 3 max nodes
- t4g.medium instances

**Prod Configuration:**
- ON_DEMAND instances
- 3 min, 10 max nodes
- t4g.large/xlarge instances
- Private API endpoint

### Bastion Module

- ARM-based Amazon Linux 2
- Elastic IP for consistent access
- SSM Session Manager support
- Security group with SSH access
- Optional SSH key authentication

**Access via SSM:**
```bash
aws ssm start-session --target <instance-id>
```

**Access via SSH:**
```bash
ssh -i ~/.ssh/id_rsa ec2-user@<bastion-ip>
```

### S3 Module

Two buckets created:

1. **Static Content Bucket**
   - Server-side encryption
   - CORS configuration
   - CloudFront OAI access
   - Public access blocked

2. **User Content Bucket**
   - Versioning (prod only)
   - Lifecycle rules (prod only)
   - Multipart upload cleanup
   - Glacier archival after 180 days

### CloudFront Module

- HTTPS-only distribution
- Custom caching behaviors
- CORS support
- Custom error pages
- Optional custom domains
- Geo-restriction support

**Cache Behaviors:**
- Default: 1 hour TTL
- Static assets: 1 day TTL
- Images: 1 day TTL

### Route53 Module

- Hosted zone management
- CloudFront A/AAAA records
- Bastion host record
- Custom DNS records
- Domain verification TXT records
- CAA records for SSL

## Accessing the EKS Cluster

Update kubeconfig:

```bash
aws eks update-kubeconfig --name dev-eks-cluster --region us-west-2
kubectl get nodes
```

## Cost Optimization

### Development Environment

- Single NAT gateway
- SPOT instances for EKS nodes
- Smaller instance types
- Reduced log retention (7 days)
- Versioning disabled
- Lifecycle rules disabled

### Production Environment

- Multi-AZ NAT gateways for HA
- ON_DEMAND instances
- Larger instance types
- Extended log retention (30 days)
- Versioning enabled
- Lifecycle rules enabled

## Maintenance

### Update Terraform Modules

```bash
cd dev/vpc
terragrunt init -upgrade
terragrunt apply
```

### Update EKS Version

Edit `kubernetes_version` in `{env}/eks/terragrunt.hcl` and apply:

```bash
cd dev/eks
terragrunt apply
```

### Destroy Resources

Destroy in reverse dependency order:

```bash
cd dev
terragrunt run-all destroy
```

## Security Best Practices

1. **Bastion Access**: Restrict `allowed_cidr_blocks` to known IPs
2. **SSH Keys**: Use SSH keys instead of passwords
3. **EKS API**: Use private endpoint for production
4. **S3 Encryption**: Server-side encryption enabled by default
5. **CloudFront**: HTTPS-only with modern TLS versions
6. **IAM Roles**: Use IRSA for pod-level permissions
7. **VPC**: Private subnets for EKS nodes

## Troubleshooting

### Backend Already Exists

If S3 bucket exists:
```bash
terragrunt init -reconfigure
```

### Dependency Errors

Ensure dependencies are deployed first:
```bash
terragrunt graph-dependencies
```

### State Lock Issues

Release DynamoDB lock:
```bash
terragrunt force-unlock <lock-id>
```

### EKS Node Issues

Check node status:
```bash
kubectl get nodes
kubectl describe node <node-name>
```

## Environment-Specific Configurations

### Development
- Single NAT gateway
- SPOT instances
- Smaller resources
- Public EKS endpoint
- Minimal log retention

### Production
- Multi-AZ NAT gateways
- ON_DEMAND instances
- Larger resources
- Private EKS endpoint
- Extended log retention
- Versioning enabled

## Additional Resources

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Support

For issues or questions:
1. Check Terragrunt logs: `terragrunt apply --terragrunt-log-level debug`
2. Review AWS CloudWatch logs
3. Consult AWS documentation

## License

This infrastructure code is provided as-is for reference and customization.
