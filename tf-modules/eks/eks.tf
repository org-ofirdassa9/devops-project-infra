module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  create_cloudwatch_log_group = false

  cluster_name    = "eks-${data.aws_region.current.name}-${var.environment}-${var.eks_name}"
  cluster_version = var.cluster_version


  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      preserve    = true
      most_recent = true

      timeouts = {
        create = "25m"
        delete = "10m"
      }
    }
    kube-proxy = {
      preserve = true
      most_recent = true
    }
    vpc-cni = {
      preserve = true
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn = module.ebs_csi_controller_role.iam_role_arn
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3a.large", "t3.large"]
    iam_role_use_name_prefix = false
    iam_role_name = "role-${module.eks.cluster_name}-nodes"
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      # ElasticLoadBalancingReadOnly = "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
    }
    enable_monitoring = false
    block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 20
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
  }

  eks_managed_node_groups = {
    one = {
      name         = "ngr-${data.aws_region.current.name}-${var.environment}-${var.eks_name}"
      desired_size = var.ngr_desired_size
      min_size     = var.ngr_min_size
      max_size     = var.ngr_max_size

      instance_types = ["t3a.medium", "t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  node_security_group_additional_rules = {
    ingress_source_security_group_id = {
      description              = "Ingress from ALB security group"
      protocol                 = "tcp"
      from_port                = 0
      to_port                  = 65535
      type                     = "ingress"
      source_security_group_id = var.sgr_alb_to_eks_id
    }
  }

  aws_auth_users = [
    for arn in var.aws_console_role_arns : {
      username = split("/", arn)[1]
      userarn  = arn
      groups   = ["system:masters"]
    }
  ]

}