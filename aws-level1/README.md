# aws-level1（AWS実践研修 初級編）

VPC・EC2・RDS・S3・ALB（ELB）・Systems Manager・CloudWatch・CloudFormation・Terraformを使って、
AWS上にWordPress環境を構築しながらAWSの基礎を学ぶ研修教材です。

## ディレクトリ構成

```
aws-level1/
├── AWS実践研修_事前準備_利用ガイド.md / .html   事前準備・課金事故防止ガイド
└── 教材/
    ├── 01_..._実践研修問題_初級編_1.3.pdf       演習問題
    ├── 02_..._実践研修手順書_初級編_1.2.pdf      構築手順書
    └── resources/                              手順書で使用する設定ファイル一式
        ├── AmazonCloudWatch-Agentconf.json      CloudWatch Agent設定
        ├── cloudformation/                      IaC（CloudFormation）テンプレート
        │   ├── network.yaml
        │   ├── database.yaml
        │   └── application.yaml
        └── terraform/                           IaC（Terraform）テンプレート
            ├── main.tf
            ├── network.tf
            ├── database.tf
            ├── variables.tf
            └── outputs.tf
```

## 研修内容（手順書の章構成）

1. VPC
2. EC2 / RDS
3. S3 / IAM
4. ELB（ALB）
5. Systems Manager / CloudWatch
6. IaC（CloudFormation / Terraform）

## 進め方

1. **事前準備**
   [AWS実践研修_事前準備_利用ガイド.md](AWS実践研修_事前準備_利用ガイド.md)に従って、AWSアカウント作成・MFA設定・課金通知設定・IAMユーザー作成までを完了する。
   （課金事故防止のため、研修開始前に必ず実施してください）
2. **演習**
   `教材/02_クラウドインフラエンジニア(AWS)実践研修手順書_初級編_1.2.pdf` の手順に従って、VPCからIaC（CloudFormation/Terraform）までAWS環境を構築する。
   `教材/resources/` 配下のテンプレート・設定ファイルを必要に応じて利用する。
3. **問題演習**
   `教材/01_クラウドインフラエンジニア(AWS)実践研修問題_初級編_1.3.pdf` の問題を解く。
4. **研修終了時**
   事前準備ガイド内の「研修終了時チェックリスト」に従い、作成したAWSリソースを全て削除し、課金が残っていないことを確認する。

> **注意：** NAT Gatewayは課金事故防止のため利用禁止です。