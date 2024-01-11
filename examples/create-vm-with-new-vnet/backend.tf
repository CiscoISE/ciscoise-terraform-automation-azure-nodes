terraform {
  backend "azurerm" {
    key = "vm_with_new_vnet_terraform.tfstate"
  }
}
