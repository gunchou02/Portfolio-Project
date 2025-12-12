variable "region" {
  description = "AWSリージョン (例: ap-northeast-1)"
  type        = string
  default     = "ap-northeast-1" # Tokyo Region
}

variable "env" {
  description = "環境名"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}
