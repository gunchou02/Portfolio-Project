# ------------------------------------------------------------------------------
# 1. VPC モジュールの呼び出し (Networking)
# ------------------------------------------------------------------------------
module "vpc" {
  source = "../../modules/vpc"

  env             = var.env
  vpc_cidr        = var.vpc_cidr
  # AZ (Availability Zone) 2개 사용 (고가용성)
  azs             = ["${var.region}a", "${var.region}c"] 
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
}

# ------------------------------------------------------------------------------
# 2. EKS モジュールの呼び出し (Cluster)
# ------------------------------------------------------------------------------
module "eks" {
  source = "../../modules/eks"

  env                 = var.env
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids # Worker Node는 Private Subnet에 배치

  # 노드 그룹 설정 (비용 절감을 위해 t3.medium 사용)
  node_instance_types = ["t3.medium"]
  desired_size        = 2
  min_size            = 1
  max_size            = 3
}
