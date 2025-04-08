# 🚀 EKS Terraform Modules

This repository contains modular, production-ready **Terraform code** to deploy an **Amazon EKS Cluster** inside a custom **VPC**, along with Node Groups and IAM role configurations.

## 📦 Modules Included

- `vpc/` - Custom VPC with subnets, route tables, NAT, and internet gateway
- `eks/` - Amazon EKS cluster setup with integrated **Node Groups** and **IAM role** configurations.

## ✅ Features

- Modular and reusable
- Remote backend ready (with state locking)
- Supports multiple AZs
- Custom IAM role setup
- Easily scalable
- Environment-ready (dev, staging, prod)

## 🚀 Getting Started

1. Clone the repo:

```bash
git clone https://github.com/Sai-devOps-8/EKS-Terraform-Modules.git
cd EKS-Terraform-Modules

2. Configure your terraform.tfvars with required inputs.

3. Initialize Terraform:
    terraform init
4. Review and apply:
    terraform plan
    terraform apply

🗂️ **Project Structure**
EKS-terraform-Modules/
├── vpc/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── eks/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── iam.tf  (if separated internally)
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
🔐 Remote Backend (optional)
If you're using a remote backend (recommended for team use), configure backend.tf with your S3 bucket and DynamoDB table.

🧰 Requirements
AWS CLI configured

Terraform 1.3+

Valid IAM credentials with access to manage VPC/EKS

🤝 Contributing
PRs and feedback welcome!

📜 License
This Terraform module is licensed under a custom “no-modification” license.
See LICENSE for details.


