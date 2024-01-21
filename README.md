
# Infrastructure Setup for AWS EKS Cluster with Terraform and Helm

This repository contains Terraform, Terragrunt and Helm configurations to set up an AWS EKS (Elastic Kubernetes Service) cluster along with various supporting components.

## AWS Console User Configuration

In `terragrunt/production/eu-west-1/eks-hms/eks/terragrunt.hcl`, update the `aws_console_role_arns` to your AWS console user's ARN. This allows your AWS console user to view the resources in the AWS Management Console.

## Route 53 Domain Configuration

In `terragrunt/production/eu-west-1/aws-alb/terragrunt.hcl`, update the `domains_name_list` to your Route 53 domain. This is required to create an alias in your hosted zone for the Application Load Balancer (ALB).

## ACM (AWS Certificate Manager) Configuration

In `terragrunt/production/eu-west-1/aws-acm/terragrunt.hcl`, update the `domain_name` to your Route 53 domain. This is necessary to generate a wildcard certificate for the domain.

## Terraform Setup

Navigate to the `terragrunt/production` directory and run the following commands to initialize and apply the Terraform configurations:

```bash
terragrunt run-all init
terragrunt run-all apply
```

## Helm Chart Deployment

After Terraform setup, perform the following steps:

1. Take the ARN of the IAM role for the grafana service-account `(role-eks-<region>-<environment>-hms-grafana)`.

2. Install the Helm chart for Prometheus and Grafana:

   ```bash
   helm upgrade -i prometheus-grafana prometheus-community/kube-prometheus-stack -n monitoring --create-namespace -f charts/kube-prometheus-stack/values.yaml
   ```

3. Take the monitoring target group ARNs from `kube-files/monitoring.yaml` and apply it:

   ```bash
   kubectl apply -f kube-files/monitoring.yaml
   ```

4. Install the Helm chart for Loki:

   ```bash
   helm upgrade -i loki -n monitoring grafana/loki-stack --set loki.image.tag=2.9.3
   ```

5. Grafana Credentials:

   - Username: admin
   - Password: prom-operator

6. Add Loki datasource in Grafana:

   - URL: http://loki:3100
   - Loki dashboard ID: 15141

7. Add CloudWatch datasource in Grafana:

   - Authentication Provider: AWS SDK Default
   - RDS Dashboard ID: 707

## Infracost Analysis

Generated cost analysis by Infracost:

```plaintext
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓
┃ Project                                                          ┃ Monthly cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━┫
┃ org-ofirdassa9/devops-project-i...t/production/eu-west-1/aws-acm ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...t/production/eu-west-1/aws-alb ┃ $18          ┃
┃ org-ofirdassa9/devops-project-i...hms/aws-alb-ingress-controller ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...oduction/eu-west-1/eks-hms/eks ┃ $106         ┃
┃ org-ofirdassa9/devops-project-i...n/eu-west-1/eks-hms/monitoring ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...duction/eu-west-1/postgres-rds ┃ $17          ┃
┃ org-ofirdassa9/devops-project-i...grunt/production/eu-west-1/vpc ┃ $35          ┃
┃ org-ofirdassa9/devops-project-i...grunt/production/eu-west-1/waf ┃ $5           ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┛
 OVERALL TOTAL                                                        $181.00 
```