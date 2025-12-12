variable "env" {
  description = "環境名 (例: prod)"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetesのバージョン (例: 1.27)"
  type        = string
  default     = "1.29" # 최신 안정 버전 권장
}

variable "vpc_id" {
  description = "EKSクラスターを作成するVPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "EKSノードグループを配置するプライベートサブネットIDのリスト"
  type        = list(string)
}

variable "node_instance_types" {
  description = "ワーカーノードのインスタンスタイプ"
  type        = list(string)
  default     = ["t3.medium"] # 프리티어는 아니지만 가장 저렴하고 안정적인 타입
}

variable "desired_size" {
  description = "オートスケーリンググループの希望ノード数"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "オートスケーリンググループの最大ノード数"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "オートスケーリンググループの最小ノード数"
  type        = number
  default     = 1
}
