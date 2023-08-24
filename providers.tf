terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id            = var.subscription
  skip_provider_registration = true
}