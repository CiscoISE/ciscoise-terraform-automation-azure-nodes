/* https://learn.microsoft.com/en-us/marketplace/programmatic-deploy-of-marketplace-products  */

data "azurerm_virtual_network" "ise_vnet" {
  name                = var.vnet_name
  resource_group_name = var.ise_resource_group
}

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
  zones               = [1, 2, 3]
  zone_balance        = true
  health_probe_id     = azurerm_lb_probe.ise_health_checks.id

  automatic_instance_repair {
    enabled      = true
    grace_period = "PT30M"
  }

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

  lifecycle {
    ignore_changes = [instances]
  }

  depends_on = [
    azurerm_marketplace_agreement.cisco_ise_marketplace_agrmt
  ]
}


resource "azurerm_private_dns_zone" "ise_vmss_private_dns_zone" {
  name                = var.ise_vmss_private_dns_zone_name
  resource_group_name = var.ise_resource_group
}


resource "azurerm_private_dns_zone_virtual_network_link" "ise_vnet_dns_link" {
  name                  = var.ise_vnet_dns_link_name
  resource_group_name   = var.ise_resource_group
  registration_enabled  = true
  private_dns_zone_name = azurerm_private_dns_zone.ise_vmss_private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.ise_vnet.id
}

/* Scaling policy  */

resource "azurerm_monitor_autoscale_setting" "ise_scaling_policy" {
  name                = "ISEAutoscaleSetting"
  resource_group_name = var.ise_resource_group
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.isevmss.id

  profile {
    name = "ISE_scaling"

    capacity {
      default = 2
      minimum = 2
      maximum = 4
    }
  }
}
