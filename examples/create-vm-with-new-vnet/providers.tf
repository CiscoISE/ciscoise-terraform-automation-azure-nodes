terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
    assert = {
      source  = "bwoznicki/assert"
      version = "0.0.1"
    }
  }
  required_version = "~>1.5.0"
}

provider "azurerm" {
  # Configuration options
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription
}

