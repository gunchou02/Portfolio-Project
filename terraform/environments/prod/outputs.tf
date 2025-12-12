output "cluster_endpoint" {
  description = "EKS コントロールプレーンのエンドポイント"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "作成された EKS クラスター名"
  value       = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "kubectl 設定コマンド"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}
