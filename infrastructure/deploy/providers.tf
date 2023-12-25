terraform {
    required_providers {
        azurerm = {
        source  = "hashicorp/azurerm"
        version = "=3.0.0"
        }
    }
}

provider "azurerm" {
    skip_provider_registration = true 
    features {}

    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    subscription_id = var.subscription_id
}

terraform {
    backend "azurerm" {
        storage_account_name = "stocrmgmteau001"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

