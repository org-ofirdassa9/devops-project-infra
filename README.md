
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

After Terraform setup, switch to the EKS cluster config with `eks update-kubeconfig --name eks-<region>-<environment>-<name>` and perform the following steps:

1. Take the ARN of the IAM role for the grafana service-account (role-<cluster_name>-grafana) to `charts/kube-prometheus-stack/values.yaml`.

2. Install the Helm chart for Prometheus and Grafana:

   ```bash
   helm upgrade -i prometheus-grafana prometheus-community/kube-prometheus-stack -n monitoring --create-namespace -f charts/kube-prometheus-stack/values.yaml
   ```

3. Take the monitoring target group ARNs and ArgoCD target group ARN to `argocd/targetgroupbinding.yaml` and apply it.

4. Install the Helm chart for Loki:

   ```bash
   helm upgrade -i loki -n monitoring grafana/loki-stack --set loki.image.tag=2.9.3
   ```

5. Log in to Grafana:

   - Username: admin
   - Password: prom-operator

6. Add Loki datasource in Grafana:

   - URL: http://loki:3100
   - Loki dashboard ID: 15141

7. Add CloudWatch datasource in Grafana:

   - Authentication Provider: AWS SDK Default
   - Set your default region
   - RDS Dashboard ID: 707

8. `helm repo add external-secrets https://charts.external-secrets.io`
   `helm upgrade -i -n external-secrets --create-namespace external-secrets external-secrets/external-secrets`

9. Add your AWS access key and secret key to `argocd/production/secret-store.yaml` and apply it

8. Log in to ArgoCD and set up this repo as a repository inside.
    
    - Username: admin
    - Password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d` 
    
9. Setup this repo in argo repositories

10. Take the ARN of the fallback and set it in `argocd/production/hms-client/targetgroupbinding.yaml`

11. Take the ARN of the backend services and set them in `argocd/production/<backend_service_name>/targetgroupbinding.yaml`

12. git push argocd/production to update the repo
    Make sure to not commit your secret-store.yaml since it has your AWS credentials!

14. run `kubectl apply -f argocd/production/hms-client-application.yaml`

15. run `kubectl apply -f argocd/production/<backend_service_name>-application.yaml`

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
┃ org-ofirdassa9/devops-project-i...oduction/eu-west-1/eks-hms/eks ┃ $137         ┃
┃ org-ofirdassa9/devops-project-i...west-1/eks-hms/metrics-process ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...n/eu-west-1/eks-hms/monitoring ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...est-1/eks-hms/report-generator ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...u-west-1/eks-hms/users-service ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...ction/eu-west-1/github-actions ┃ $0.00        ┃
┃ org-ofirdassa9/devops-project-i...duction/eu-west-1/postgres-rds ┃ $17          ┃
┃ org-ofirdassa9/devops-project-i...grunt/production/eu-west-1/vpc ┃ $35          ┃
┃ org-ofirdassa9/devops-project-i...grunt/production/eu-west-1/waf ┃ $11          ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┛
 OVERALL TOTAL                                                       $218.00 
```