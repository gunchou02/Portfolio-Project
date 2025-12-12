# ☁️ AWS EKSを活用した高可用性GitOpsインフラ構築プロジェクト

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![ArgoCD](https://img.shields.io/badge/ArgoCD-%23EF7B4D.svg?style=for-the-badge&logo=argo&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)

## 📖 概要 (Overview)
本プロジェクトは、**Infrastructure as Code (IaC)** および **GitOps** 手法を取り入れ、AWS上で高可用性と拡張性を備えたWebサービス基盤を構築したインフラエンジニアリングのポートフォリオです。

単なるサーバー構築にとどまらず、**Terraform**によるインフラの自動プロビジョニング、**Amazon EKS (Kubernetes)** を活用したコンテナオーケストレーション、そして **ArgoCD** によるCDパイプラインの構築を行い、モダンな開発・運用フローを再現しました。

デプロイされたアプリケーションは **Python FastAPI** で開発されており、Podのホスト名やサーバー状態を可視化することで、ロードバランシングやオートスケーリングの動作を検証できるように設計されています。

---

## 🏗️ アーキテクチャ (Architecture)

*(ここにアーキテクチャ図を挿入してください)*
> **構成概要:**
> User Traffic -> AWS ALB -> EKS (Node Group) -> Service -> Python Pods

---

### 🔧 技術スタック (Tech Stack)

| カテゴリ | 技術 (Technology) | 選定理由 (Why?) |
|:---:|:---:|:---|
| **Cloud Provider** | **AWS** | 市場シェアNo.1であり、多くの企業で標準採用されているため |
| **IaC** | **Terraform** | インフラのバージョン管理およびヒューマンエラー防止（宣言的コード管理） |
| **Orchestration** | **Amazon EKS** | マネージドKubernetesによる運用コストの削減と安定性の確保 |
| **CI/CD** | **GitHub Actions** & **ArgoCD** | ビルドの自動化(CI)およびGitOpsベースの継続的デリバリー(CD)の実装 |
| **Web App** | **Python (FastAPI)** | 非同期処理に強く、軽量かつモダンなWebフレームワーク |
| **Monitoring** | **Prometheus** & **Grafana** | クラスターおよびアプリケーションリソースのリアルタイム可視化 |

---

## 🚀 主な機能 (Key Features)

1.  **インフラの完全コード化 (100% Terraform)**
    * VPC, Subnet, Security Group などのネットワーク層から EKS クラスターまで、全て Terraform モジュールで管理。
    * State ファイル管理により、インフラ構成の整合性を維持。

2.  **GitOps ベースの自動デプロイパイプライン**
    * ソースコードの変更をトリガーに GitHub Actions が Docker Image をビルドし、ECR へプッシュ。
    * ArgoCD がマニフェストの変更を検知し、EKS クラスターへ自動的に同期 (Sync)。

3.  **オートスケーリング (HPA & CA)**
    * **HPA (Horizontal Pod Autoscaler):** CPU使用率の上昇に伴い、Pod数を自動でスケールアウト。
    * **Cluster Autoscaler:** ノードリソース不足時、ワーカーノード(EC2)を自動追加。

4.  **検証用 Web アプリケーション**
    * アクセスごとに処理を担当している **PodのIPとホスト名** を表示し、ロードバランシングの動作を視覚的に確認可能。
    * システムリソース(CPU/Memory)の使用率をリアルタイムで表示。

---

## 📂 ディレクトリ構成 (Directory Structure)
```bash
.
├── 📂 app                 # Python FastAPI アプリケーションのソースコード
│   ├── Dockerfile        # コンテナイメージのビルド定義ファイル
│   └── main.py           # アプリケーションのエントリーポイント
├── 📂 terraform           # AWSインフラ構築用 Terraform コード
│   ├── modules/          # 再利用可能なモジュール (VPC, EKS 等)
│   └── environments/     # 環境ごとの構成定義 (dev/prod)
├── 📂 k8s-manifests       # Kubernetes リソース定義 (Deployment, Service, Ingress)
│   └── base/             # Kustomize Base 設定
└── 📂 .github
    └── workflows/        # GitHub Actions CI パイ프ライン設定
```
---

## 🛠️ 開始方法 (Getting Started)

1. 前提条件 (Prerequisites) AWS CLI & Configure 設定済み

 * Terraform インストール済み

 * Docker インストール済み

 * Kubectl インストール済み

2. インフラのプロビジョニング (Infrastructure Provisioning)
```bash
cd terraform/environments/prod
terraform init
terraform apply -auto-approve
```
3. アプリケーションのデプロイ (Application Deployment)
ArgoCD により k8s-manifests リポジトリが同期されると、自動的にアプリケーションがデプロイされます。

---

## 💡 トラブルシューティングと学び (Learning Points)

(開発中に直面した課題とその解決策を記述予定)

* Issue 1: Terraform State Lock の競合解決プロセス

* Issue 2: ALB Ingress Controller 設定時の Subnet Tagging 問題

---

## 📬 Contact

Name: [PARK JEONGBIN]

Email: [gunchou02@gmail.com]
