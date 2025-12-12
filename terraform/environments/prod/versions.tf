terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # ⚠️ 중요: 나중에 S3에 tfstate를 저장할 때 이곳의 주석을 풉니다.
  # backend "s3" { ... }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "aws-eks-gitops"
      Environment = "prod"
      ManagedBy   = "Terraform"
      Owner       = "PortfolioUser"
    }
  }
}
