terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.40.0"
    }
  }
  backend "azurerm" {
    key            = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# resource group
data "azurerm_resource_group" "main" {
  name = "rg-${var.org_infix}-wordpress-infra-v2-${var.env_suffix}"
}