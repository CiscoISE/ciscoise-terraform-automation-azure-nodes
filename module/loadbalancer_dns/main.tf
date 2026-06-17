# Copyright 2024 Cisco Systems, Inc. and its affiliates
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

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
  count               = local.create_nlb ? 1 : 0
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
  count = local.create_nlb ? 1 : 0

  loadbalancer_id = azurerm_lb.ise-lb[0].id
  name            = var.ise_lb_backend_address_pool_name

  depends_on = [azurerm_lb.ise-lb]
}


/* Registering nodes in loadbalancer backend pool */

resource "azurerm_lb_backend_address_pool_address" "ise-vm" {
  for_each                = local.create_nlb ? toset(local.enabled_nodes) : []
  name                    = "ISE-backend-vm-ip-${each.key}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ise-vm-backendpool[0].id
  virtual_network_id      = data.azurerm_virtual_network.ise_vnet.id
  ip_address              = data.azurerm_virtual_machine.ise_vm_nic_ip[each.key].private_ip_address
  depends_on = [
    azurerm_lb_backend_address_pool.ise-vm-backendpool
  ]
}


/* Health probe for backend */

resource "azurerm_lb_probe" "ise_health_checks" {
  count               = local.create_nlb ? 1 : 0
  loadbalancer_id     = azurerm_lb.ise-lb[0].id
  name                = "https-probe"
  protocol            = "Tcp"
  port                = 443
  interval_in_seconds = 15
  number_of_probes    = 2

  depends_on = [azurerm_lb.ise-lb]
}


/*     Loadbalancer Rules for backend communication     */


resource "azurerm_lb_rule" "ise-lb-rule-psn-1" {
  count                          = local.create_nlb ? 1 : 0
  loadbalancer_id                = azurerm_lb.ise-lb[0].id
  name                           = "ise-lb-rule-psn-1"
  protocol                       = "Udp"
  frontend_port                  = 1812
  backend_port                   = 1812
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks[0].id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool[0].id]

  depends_on = [azurerm_lb.ise-lb]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-2" {
  count                          = local.create_nlb ? 1 : 0
  loadbalancer_id                = azurerm_lb.ise-lb[0].id
  name                           = "ise-lb-rule-psn-2"
  protocol                       = "Udp"
  frontend_port                  = 1813
  backend_port                   = 1813
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks[0].id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool[0].id]

  depends_on = [azurerm_lb.ise-lb]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-3" {
  count                          = local.create_nlb ? 1 : 0
  loadbalancer_id                = azurerm_lb.ise-lb[0].id
  name                           = "ise-lb-rule-psn-3"
  protocol                       = "Tcp"
  frontend_port                  = 49
  backend_port                   = 49
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks[0].id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool[0].id]

  depends_on = [azurerm_lb.ise-lb]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-4" {
  count                          = local.create_nlb ? 1 : 0
  loadbalancer_id                = azurerm_lb.ise-lb[0].id
  name                           = "ise-lb-rule-psn-4"
  protocol                       = "Udp"
  frontend_port                  = 1645
  backend_port                   = 1645
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks[0].id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool[0].id]

  depends_on = [azurerm_lb.ise-lb]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-5" {
  count                          = local.create_nlb ? 1 : 0
  loadbalancer_id                = azurerm_lb.ise-lb[0].id
  name                           = "ise-lb-rule-psn-5"
  protocol                       = "Udp"
  frontend_port                  = 1646
  backend_port                   = 1646
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks[0].id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool[0].id]

  depends_on = [azurerm_lb.ise-lb]
}

resource "azurerm_lb_rule" "ise-lb-rule-psn-gui" {
  count                          = local.create_nlb ? 1 : 0
  loadbalancer_id                = azurerm_lb.ise-lb[0].id
  name                           = "ise-lb-rule-psn-gui"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = var.frontend_lb_ip_name
  probe_id                       = azurerm_lb_probe.ise_health_checks[0].id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ise-vm-backendpool[0].id]
  load_distribution              = "SourceIPProtocol"

  depends_on = [azurerm_lb.ise-lb]
}


######################################### Private Endpoint Configuration for Function App Storage Account #########################################

resource "azurerm_private_endpoint" "ise-app-storage-endpoint" {
  name                = "ise-app-storage-endpoint"
  location            = var.location
  resource_group_name = var.ise_resource_group
  subnet_id           = data.azurerm_subnet.ise_lb_subnet.id

  private_service_connection {
    name                           = "ise-app-storage-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.ise-app-storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ise-app-storage-private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.ise-app-storage-private-dns-zone.id]
  }
}

resource "azurerm_private_dns_zone" "ise-app-storage-private-dns-zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.ise_resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "ise-app-storage-dns-vnet-link" {
  name                  = "ise-app-storage-dns-vnet-link"
  resource_group_name   = var.ise_resource_group
  private_dns_zone_name = azurerm_private_dns_zone.ise-app-storage-private-dns-zone.name
  virtual_network_id    = data.azurerm_virtual_network.ise_vnet.id
}


######################################### Private Endpoint Configuration for Function App  #########################################

resource "azurerm_private_endpoint" "ise-function-app-endpoint" {
  name                = "ise-function-app-endpoint"
  location            = var.location
  resource_group_name = var.ise_resource_group
  subnet_id           = data.azurerm_subnet.ise_lb_subnet.id

  private_service_connection {
    name                           = "ise-function-app-privateserviceconnection"
    private_connection_resource_id = azurerm_linux_function_app.ise-function-app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ise-function-app-private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.ise-function-app-private-dns-zone.id]
  }
}

resource "azurerm_private_dns_zone" "ise-function-app-private-dns-zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.ise_resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "ise-function-app-dns-vnet-link" {
  name                  = "ise-function-app-dns-vnet-link"
  resource_group_name   = var.ise_resource_group
  private_dns_zone_name = azurerm_private_dns_zone.ise-function-app-private-dns-zone.name
  virtual_network_id    = data.azurerm_virtual_network.ise_vnet.id
}
