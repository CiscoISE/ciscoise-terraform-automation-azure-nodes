terraform {
  backend "azurerm" {
    key = "vm_with_existing_vnet_terraform.tfstate"
  }
}
