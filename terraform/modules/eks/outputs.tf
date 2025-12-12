output "cluster_id" {
  description = "EKSクラスターID"
  value       = aws_eks_cluster.main.id
}

output "cluster_endpoint" {
  description = "EKSコントロールプレーンのエンドポイントURL"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "kubectlの設定に必要なクラスターCAデータ"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "oidc_provider_arn" {
  description = "IAM Roles for Service Accounts (IRSA) 用のOIDCプロバイダーARN"
  value       = aws_iam_openid_connect_provider.cluster.arn
}

output "cluster_name" {
  description = "EKSクラスター名"
  value       = aws_eks_cluster.main.name
}
