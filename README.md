
# Infrastructure Setup for AWS EKS Cluster with OpenTofu and Helm

This repository contains OpenTofu, Terragrunt and ArgoCD configurations to set up an AWS EKS (Elastic Kubernetes Service) cluster along with various supporting components.

## AWS Console User Configuration

In `terragrunt/production/eu-west-1/eks-hms/eks/terragrunt.hcl`, update the `aws_console_role_arns` to your AWS console user's ARN. This allows your AWS console user to view the resources in the AWS Management Console.

## Route 53 Domain Configuration

In `terragrunt/production/eu-west-1/aws-alb/terragrunt.hcl`, update the `domains_name_list` to your Route 53 domain. This is required to create an alias in your hosted zone for the Application Load Balancer (ALB).

## ACM (AWS Certificate Manager) Configuration

In `terragrunt/production/eu-west-1/aws-acm/terragrunt.hcl`, update the `domain_name` to your Route 53 domain. This is necessary to generate a wildcard certificate for the domain.

## OpenTofu Setup

Navigate to the `terragrunt/production` directory and run the following commands to initialize and apply the OpenTofu configurations:

```bash
terragrunt run-all init
terragrunt run-all apply
```

## Helm Chart Deployment

After OpenTofu setup, switch to the EKS cluster config with `aws eks update-kubeconfig --name eks-<region>-<environment>-<name>` and perform the following steps:

1. Log in to Grafana:

   - Username: admin
   - Password: prom-operator

2. Add Loki datasource in Grafana:

   - URL: http://loki:3100
   - Loki dashboard ID: 15141

3. Add CloudWatch datasource in Grafana:

   - Authentication Provider: AWS SDK Default
   - Set your default region
   - RDS Dashboard ID: 707

4. Log in to ArgoCD and set up this repo as a repository inside.
    
    - Username: admin
    - Password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d` 
    
5. Take the ARN of the fallback and set it in `argocd/production/hms-client/targetgroupbinding.yaml`

6. Take the ARN of the backend services and set them in `argocd/production/<backend_service_name>/targetgroupbinding.yaml`

7. git push argocd/production to update the repo
    Make sure to not commit your secret-store.yaml since it has your AWS credentials!

8. MANUALLY create secrets for the backend services in AWS Secrets manager `/eks/<environment>/<service-name>`:
    each should have 3 secrets:
    - `PROJECT_NAME` ex: Users Service
    - `JWT_SECRET_KEY` ex: your-secret-key
    - `DB_CONN_STRING` ex: postgresql://<pg_username>:<pg_password>@<pg_endpoint>/<db_name>

9. run `kubectl apply -f argocd/production/hms-client-application.yaml`

10. Add your AWS access key and secret key in base64 format to `argocd/production/secret-store.yaml` and apply it

11. run `kubectl apply -f argocd/production/users-service-application.yaml`

12. run `kubectl apply -f argocd/production/metrics-process-application.yaml`

13. run `kubectl apply -f argocd/production/report-generator-application.yaml`

## Infracost Analysis

Generated cost analysis by Infracost:

```plaintext
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓
┃ Project                                                          ┃ Monthly cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━┫
┃ org-ofirdassa9/devops-project-i...t/production/eu-west-1/aws-acm ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...t/production/eu-west-1/aws-alb ┃ $18          ┃
┃ org-ofirdassa9/devops-project-i...ction/eu-west-1/eks-hms/argocd ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...hms/aws-alb-ingress-controller ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...oduction/eu-west-1/eks-hms/eks ┃ $169         ┃
┃ org-ofirdassa9/devops-project-i...est-1/eks-hms/external-secrets ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...west-1/eks-hms/metrics-process ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...n/eu-west-1/eks-hms/monitoring ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...est-1/eks-hms/report-generator ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...u-west-1/eks-hms/users-service ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...ction/eu-west-1/github-actions ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...duction/eu-west-1/postgres-rds ┃ $17          ┃
┃ org-ofirdassa9/devops-project-i...grunt/production/eu-west-1/vpc ┃ $35          ┃
┃ org-ofirdassa9/devops-project-i...grunt/production/eu-west-1/waf ┃ $11          ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┛
 OVERALL TOTAL                                                       $250.00 
```