# ------------------------------------------------------------------------------
# 1. VPC モジュールの呼び出し (Networking)
# ------------------------------------------------------------------------------
module "vpc" {
  source = "../../modules/vpc"

  env             = var.env
  vpc_cidr        = var.vpc_cidr
  
  # 高可用性 (High Availability) のため、2つのAZを使用
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
  
  # Worker Nodeはセキュリティのためプライベートサブネットに配置
  subnet_ids          = module.vpc.private_subnet_ids 

  # ノードグループ設定 (コスト削減のため t3.medium を使用)
  node_instance_types = ["t3.medium"]
  desired_size        = 2
  min_size            = 1
  max_size            = 3
}

# ------------------------------------------------------------------------------
# 3. ECR リポジトリ (Container Registry)
# Dockerイメージを保存する場所
# ------------------------------------------------------------------------------
resource "aws_ecr_repository" "app" {
  name                 = "python-web-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ------------------------------------------------------------------------------
# 4. AWS Load Balancer Controller (ALBを作成するために必須)
# ------------------------------------------------------------------------------

# EKSクラスター情報の取得 (Helm Provider用)
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# Helm Provider 設定
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# IAM Role 作成 (LBコントローラー用 - IRSA)
# AWS公式のモジュールを使用して、安全に権限を付与します
module "lb_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "${var.env}-eks-lb-role"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# Helm Chart インストール (コントローラーのデプロイ)
resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.lb_role.iam_role_arn
  }
}