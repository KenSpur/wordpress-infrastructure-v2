# 🗺️ wordpress-infrastructure-v2

## 🛠️ Technologies used
- [Dev Container](https://code.visualstudio.com/docs/devcontainers/create-dev-container) Docker container as a full-featured development environment
- [Github Codespaces](https://github.com/features/codespaces) Fully configured dev environments in the cloud
- [Terraform](https://www.terraform.io/) Infrastructure as Code tool

## 🎯 Targets
- [Azure](https://portal.azure.com/) Cloud computing platform


## 🫳 Usage

### ⌨️ Log in

```shell
az login
az account set -s $subscription_id
```

### ⌨️ Terraform init

```shell
terraform init \
    -backend-config="resource_group_name=$backend_resource_group_name" \
    -backend-config="storage_account_name=$backend_storage_account_name" \
    -backend-config="container_name=$backend_container_name"
```