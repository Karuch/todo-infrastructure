module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "talk"
  cluster_version = "1.25"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]]
  control_plane_subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]] #I understood it's good for it have more private IPs for redun and not pub for sec..

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = "t3a.large"
    update_launch_template_default_version = true
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }

  self_managed_node_groups = {
    one = {
      name         = "mixed-1"
      max_size     = 2
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }

        override = [
          {
            instance_type     = "t3a.large"
            weighted_capacity = "1"
          }
        ]
      }
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3a.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_types = ["t3a.large"]
      capacity_type  = "SPOT"
    }
  }

# Fargate Profile(s)
#  fargate_profiles = {
#    default = {
#     name = "default"
#      selectors = [
#        {
#          namespace = "default"
#        }
#      ]
#      private_subnet_selector = {
#          subnet_ids = module.vpc.private_subnets
#      }
#    }
#  }

  # aws-auth configmap
  #manage_aws_auth_configmap = true

  #aws_auth_roles = [
  #  {
  #    rolearn  = "arn:aws:iam::644435390668:role/administrator"
  #    username = "talk"
  #    groups   = ["system:masters"]
  #  },
  #]

  #aws_auth_users = [
  #  {
  #    userarn  = "arn:aws:iam::644435390668:user/administrator"
  #    username = "talk"
  #    groups   = ["system:masters"]
  #  },
  #  {
  #    userarn  = "arn:aws:iam::644435390668:user/administrator"
  #    username = "talk"
  #    groups   = ["system:masters"]
  #  },
  #]

  #aws_auth_accounts = [
  #  "644435390668"
  #]

}