variable "env" {
  description = "環境名 (例: dev, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック (例: 10.0.0.0/16)"
  type        = string
}

variable "public_subnets" {
  description = "パブリックサブネットのCIDRリスト"
  type        = list(string)
}

variable "private_subnets" {
  description = "プライベートサブネットのCIDRリスト"
  type        = list(string)
}

variable "azs" {
  description = "使用するアベイラビリティーゾーンのリスト"
  type        = list(string)
}
