data "azurerm_subnet" "ise_vmss_subnet" {
  name                 = var.ise_vmss_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.ise_resource_group
}

data "azurerm_subnet" "ise_lb_subnet" {
  name                 = var.ise_lb_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.ise_resource_group
}

output "subnet_id" {
  value = data.azurerm_subnet.ise_lb_subnet.id
}

/*
resource "azurerm_resource_group" "vmss" {
  name     = "LoadBalancerRG"
  location = "East US"
}
*/

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

resource "azurerm_lb_backend_address_pool" "ise-vmss-backendpool" {
  loadbalancer_id = azurerm_lb.ise-lb.id
  name            = var.ise_lb_backend_address_pool_name
}

/*
resource "azurerm_lb_backend_address_pool_address" "backendpool-associate" {
  name = "ISE-backend-vmss"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ise-vmss-backendpool.id
  backend_address_ip_configuration_id = azurerm_lb.ise-lb.frontend_ip_configuration[0].id
}

*/

/* Health probe for backend */

resource "azurerm_lb_probe" "ise_health_checks" {
  loadbalancer_id     = azurerm_lb.ise-lb.id
  name                = "https-probe"
  protocol            = "Https"
  port                = 443
  interval_in_seconds = 15
  number_of_probes    = 2
  request_path        = "/"
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
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vmss-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-2" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-2"
  protocol                       = "Udp"
  frontend_port                  = 1813
  backend_port                   = 1813
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vmss-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-3" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-3"
  protocol                       = "Tcp"
  frontend_port                  = 49
  backend_port                   = 49
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vmss-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-4" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-4"
  protocol                       = "Udp"
  frontend_port                  = 1645
  backend_port                   = 1645
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vmss-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-5" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-5"
  protocol                       = "Udp"
  frontend_port                  = 1646
  backend_port                   = 1646
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vmss-backendpool.id]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-gui" {
  loadbalancer_id                = azurerm_lb.ise-lb.id
  name                           = "ise-lb-rule-psn-gui"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vmss-backendpool.id]
}