terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "talk-terraform"      
    key = "s3://portfolio"
    region = "eu-west-3" 
  }
}

# Configure the AWS Provider
provider "aws" {
    region = "eu-west-3"
    default_tags {
        tags = {
            Owner = var.tags["Owner"]
            bootcamp = var.tags["bootcamp"]
            expiration_date = var.tags["expiration_date"]
            sign = var.tags["sign"] 
        }
    }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

