terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
  }
  required_version = "1.5.5"
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id            = var.subscription
  skip_provider_registration = true
}

