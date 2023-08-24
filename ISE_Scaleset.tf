/* https://learn.microsoft.com/en-us/marketplace/programmatic-deploy-of-marketplace-products  */

data "azurerm_subnet" "ise_vmss_subnet" {
  name                 = var.ise_vmss_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.ise_resource_group
}


resource "azurerm_marketplace_agreement" "cisco_ise_marketplace_agrmt" {
  publisher = var.ise_publisher
  offer     = var.ise_offer
  plan      = var.ise_plan_name
}

resource "azurerm_linux_virtual_machine_scale_set" "isevmss" {
  name                = var.ise_vm_scaleset_name
  resource_group_name = var.ise_resource_group
  location            = var.location
  sku                 = var.ise_vm_size_sku
  instances           = var.ise_vmss_vm_count
  admin_username      = var.ise_vm_adminuser_name
  user_data           = base64encode(file("./user-data"))

  admin_ssh_key {
    username   = var.ise_vm_adminuser_name
    public_key = file("./isekey.pub")
  }

  source_image_reference {
    publisher = var.ise_publisher
    offer     = var.ise_offer
    sku       = var.ise_image_sku
    version   = var.ise_image_version
  }
  plan {
    name      = var.ise_plan_name
    publisher = var.ise_publisher
    product   = var.ise_plan_product
  }

  os_disk {
    storage_account_type = var.ise_vmss_vm_storage_account_type
    caching              = var.ise_vmss_vm_sa_caching
  }

  network_interface {
    name    = var.ise_vmss_vm_nic_name
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = data.azurerm_subnet.ise_vmss_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.ise-vmss-backendpool.id]
    }
  }
  depends_on = [
    azurerm_marketplace_agreement.cisco_ise_marketplace_agrmt
  ]
}




