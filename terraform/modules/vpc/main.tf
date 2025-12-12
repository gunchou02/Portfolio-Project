# ------------------------------------------------------------------------------
# VPCの作成
# ------------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # EKSノードがホスト名を持つために必要
  enable_dns_support   = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

# ------------------------------------------------------------------------------
# インターネットゲートウェイ (IGW) - パブリック通信用
# ------------------------------------------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# ------------------------------------------------------------------------------
# パブリックサブネット (Public Subnets)
# 用途: ALB (Load Balancer), NAT Gateway
# ------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  # パブリックIPを自動割り当て
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-subnet-${count.index + 1}"
    
    # AWS Load Balancer ControllerがALBを作成するために必須のタグ
    "kubernetes.io/role/elb" = "1" 
    "kubernetes.io/cluster/${var.env}-eks-cluster" = "shared"
  }
}

# ------------------------------------------------------------------------------
# プライベートサブネット (Private Subnets)
# 用途: EKS Worker Nodes, RDS (Database)
# ------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.env}-private-subnet-${count.index + 1}"
    
    # AWS Load Balancer ControllerがInternal ALBを作成するために必須のタグ
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.env}-eks-cluster" = "shared"
  }
}

# ------------------------------------------------------------------------------
# NATゲートウェイ (NAT Gateway) & Elastic IP
# 用途: プライベートサブネットのノードが外部(インターネット)へ通信するため
# ※ EKSノードがDockerイメージをPullするために必須
# ------------------------------------------------------------------------------
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # 最初のパブリックサブネットに配置

  tags = {
    Name = "${var.env}-nat-gw"
  }

  # IGWが作成されてから作成する依存関係
  depends_on = [aws_internet_gateway.main]
}

# ------------------------------------------------------------------------------
# ルートテーブル (Route Tables)
# ------------------------------------------------------------------------------

# パブリックルートテーブル (IGWへ向かう)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

# プライベートルートテーブル (NAT Gatewayへ向かう)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.env}-private-rt"
  }
}

# ------------------------------------------------------------------------------
# ルートテーブルの関連付け (Route Table Association)
# ------------------------------------------------------------------------------
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
