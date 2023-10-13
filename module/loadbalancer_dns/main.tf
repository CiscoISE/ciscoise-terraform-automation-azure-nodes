data "azurerm_virtual_network" "ise_vnet" {
  name                = var.vnet_name
  resource_group_name = var.ise_resource_group
}

data "azurerm_subnet" "ise_lb_subnet" {
  name                 = var.ise_lb_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.ise_resource_group
}


data "azurerm_virtual_machine" "ise_vm_nic_ip" {
  for_each            = toset(local.ise_node_name)
  name                = each.key
  resource_group_name = var.ise_resource_group
}

locals {
  ise_node_name             = var.ise_node_names
  appConIP                  = var.appConIP
  pan_node                  = var.ise_pan_node_names
  psn_node                  = var.ise_psn_node_names
  combined_key_value        = zipmap(local.appConIP, local.pan_node)
  appConfqdn                = var.appConfqdn
  combined_pan_kv_fqdn      = zipmap(local.appConfqdn, local.pan_node)
  combined_psn_kv_fqdn      = zipmap(local.psn_node, local.psn_node)
  username_password_key     = var.username_password_key
  username_password_value   = [var.ise_vm_adminuser_name, var.password]
  combined_user_password_kv = zipmap(local.username_password_key, local.username_password_value)
}



/* Creating a Private hosted zone for the ISE Virtual Machine FQDN */

resource "azurerm_private_dns_zone" "ise_vm_private_dns_zone" {
  name                = var.ise_vm_private_dns_zone_name
  resource_group_name = var.ise_resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "ise_vnet_dns_link" {
  name                = var.ise_vnet_dns_link_name
  resource_group_name = var.ise_resource_group
  # registration_enabled  = true
  private_dns_zone_name = azurerm_private_dns_zone.ise_vm_private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.ise_vnet.id

  lifecycle {
    ignore_changes = [virtual_network_id]
  }
}

/* Creating Private DNS hosted zone and enabling auto-registration on Virtual Machine creation */


resource "azurerm_private_dns_a_record" "ise_vm_dns_record" {
  for_each            = toset(local.ise_node_name)
  name                = each.key
  zone_name           = azurerm_private_dns_zone.ise_vm_private_dns_zone.name
  resource_group_name = var.ise_resource_group
  ttl                 = 300
  records             = [data.azurerm_virtual_machine.ise_vm_nic_ip[each.key].private_ip_address]

}

/* Creating a Network loadbalancer for the ISE PAN nodes */

resource "azurerm_lb" "ise-lb" {
  name                = var.ise_lb_name
  location            = var.location
  resource_group_name = var.ise_resource_group
  sku                 = var.ise_lb_sku

  frontend_ip_configuration {
    name                          = var.frontend_lb_ip_name
    private_ip_address_allocation = var.frontend_ip_allocation
    subnet_id                     = data.azurerm_subnet.ise_lb_subnet.id
  }
}


/* Crreating a Backend Pool for the Nodes */

resource "azurerm_lb_backend_address_pool" "ise-vm-backendpool" {
  loadbalancer_id = azurerm_lb.ise-lb.id
  name            = var.ise_lb_backend_address_pool_name

  depends_on = [azurerm_lb.ise-lb]
}


/* Registering nodes in loadbalancer backend pool */

resource "azurerm_lb_backend_address_pool_address" "ise-vm" {
  for_each                = toset(local.ise_node_name)
  name                    = "ISE-backend-vm-ip-${each.key}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ise-vm-backendpool.id
  virtual_network_id      = data.azurerm_virtual_network.ise_vnet.id
  ip_address              = data.azurerm_virtual_machine.ise_vm_nic_ip[each.key].private_ip_address
  depends_on = [
    azurerm_lb_backend_address_pool.ise-vm-backendpool
  ]
}


/* Health probe for backend */

resource "azurerm_lb_probe" "ise_health_checks" {
  loadbalancer_id     = azurerm_lb.ise-lb.id
  name                = "https-probe"
  protocol            = "Tcp"
  port                = 443
  interval_in_seconds = 15
  number_of_probes    = 2
}


/*     Loadbalancer Rules for backend communication     */


resource "azurerm_lb_rule" "ise-lb-rule-psn-1" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-1"
  protocol                       = "Udp"
  frontend_port                  = 1812
  backend_port                   = 1812
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-2" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-2"
  protocol                       = "Udp"
  frontend_port                  = 1813
  backend_port                   = 1813
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-3" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-3"
  protocol                       = "Tcp"
  frontend_port                  = 49
  backend_port                   = 49
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-4" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-4"
  protocol                       = "Udp"
  frontend_port                  = 1645
  backend_port                   = 1645
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-5" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-5"
  protocol                       = "Udp"
  frontend_port                  = 1646
  backend_port                   = 1646
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-gui" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-gui"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool.id]
  load_distribution              = "SourceIPProtocol"
}
