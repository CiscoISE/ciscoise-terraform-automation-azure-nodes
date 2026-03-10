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


# Resource group creation
resource "azurerm_resource_group" "cisco_ise_rg" {
  name     = var.ise_resource_group # "Cisco_ISE_ResourceGroup"
  location = var.location           # Change this to your desired location
  tags = {
    Name = "CiscoISE-ResourceGroup"
  }
}

#Virtual Network creation
resource "azurerm_virtual_network" "cisco_ise" {
  name                = var.vnet_name
  address_space       = [var.vnet_address]
  location            = azurerm_resource_group.cisco_ise_rg.location
  resource_group_name = azurerm_resource_group.cisco_ise_rg.name

  tags = {
    Name = var.vnet_name
  }
}

# Subnet creation 
resource "azurerm_subnet" "public_subnets" {
  count                = length(var.public_subnet_cidrs)
  name                 = "PublicSubnet-${count.index}"
  virtual_network_name = azurerm_virtual_network.cisco_ise.name
  resource_group_name  = azurerm_resource_group.cisco_ise_rg.name
  address_prefixes     = [var.public_subnet_cidrs[count.index]] #["10.0.${count.index + 1}.0/24"] for 3 subnets
}

resource "azurerm_subnet" "private_subnets" {
  count                = length(var.private_subnet_cidrs)
  name                 = "PrivateSubnet-${count.index}"
  virtual_network_name = azurerm_virtual_network.cisco_ise.name
  resource_group_name  = azurerm_resource_group.cisco_ise_rg.name
  address_prefixes     = [var.private_subnet_cidrs[count.index]] #["10.0.${count.index + 2}.0/24"] for 3 subnets
}


#creating NSG (based on public_subnetscount)
resource "azurerm_network_security_group" "cisco_ise_public_nsg" {
  count               = length(azurerm_subnet.public_subnets)
  name                = "cisco_ise-public-network-security-group-${count.index}"
  location            = azurerm_resource_group.cisco_ise_rg.location
  resource_group_name = azurerm_resource_group.cisco_ise_rg.name
}

#Attaching NSG to each of the public_subnets
resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  count = length(var.public_subnet_nsg_associations)

  subnet_id                 = azurerm_subnet.public_subnets[var.public_subnet_nsg_associations[count.index].subnet_index].id
  network_security_group_id = azurerm_network_security_group.cisco_ise_public_nsg[var.public_subnet_nsg_associations[count.index].nsg_index].id
}

#creating NSG (based on private_subnet count)
resource "azurerm_network_security_group" "cisco_ise_private_nsg" {
  count               = length(azurerm_subnet.private_subnets)
  name                = "cisco_ise-private-network-security-group-${count.index}"
  location            = azurerm_resource_group.cisco_ise_rg.location
  resource_group_name = azurerm_resource_group.cisco_ise_rg.name
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_association" {
  count = length(var.private_subnet_nsg_associations)

  subnet_id                 = azurerm_subnet.private_subnets[var.private_subnet_nsg_associations[count.index].subnet_index].id
  network_security_group_id = azurerm_network_security_group.cisco_ise_private_nsg[var.private_subnet_nsg_associations[count.index].nsg_index].id
}


#Public IP resources for Azure NAT Gateway
resource "azurerm_public_ip" "cisco_ise_public_ips" {
  # count                = 1                                   #length(azurerm_subnet.public_subnets)
  name                = "CiscoISE-NAT-GW_PIP" # "CiscoISE-NAT-${count.index}"
  location            = azurerm_resource_group.cisco_ise_rg.location
  resource_group_name = azurerm_resource_group.cisco_ise_rg.name
  allocation_method   = "Static"
  sku                 = "Standard" # or "Basic" depending on your needs

}

#Azure NAT Gateway configuration 
resource "azurerm_nat_gateway" "cisco_ise_nat_gateways" {
  #  count                   = 1                                 #length(azurerm_subnet.public_subnets) 
  name                    = "CiscoISE-NAT-GW" # "nat-Gateway-${count.index}"
  location                = azurerm_resource_group.cisco_ise_rg.location
  resource_group_name     = azurerm_resource_group.cisco_ise_rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  # zones                   = ["1"]
}

# Association between a Nat Gateway and a Public IP
resource "azurerm_nat_gateway_public_ip_association" "associate_NAT_GW_Public_IP" {
  nat_gateway_id       = azurerm_nat_gateway.cisco_ise_nat_gateways.id
  public_ip_address_id = azurerm_public_ip.cisco_ise_public_ips.id
}

# Associates a NAT Gateway with Private Subnets within a Virtual Network.
resource "azurerm_subnet_nat_gateway_association" "azurerm_nat_gateway_private_subnets_association" {
  count          = length(var.private_subnet_cidrs)
  nat_gateway_id = azurerm_nat_gateway.cisco_ise_nat_gateways.id
  subnet_id      = azurerm_subnet.private_subnets[count.index].id
}


resource "azurerm_subnet" "ise_func_subnet" {
  name                 = var.ise_func_subnet
  resource_group_name  = azurerm_resource_group.cisco_ise_rg.name
  virtual_network_name = azurerm_virtual_network.cisco_ise.name
  address_prefixes     = var.ise_func_subnet_cidr

  delegation {
    name = "funcapp-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
} 

resource "azurerm_network_security_group" "ise_func_subnet_nsg" {
  name                = "cisco_ise-ise_func_subnet_nsg"
  location            = azurerm_resource_group.cisco_ise_rg.location
  resource_group_name = azurerm_resource_group.cisco_ise_rg.name
}

resource "azurerm_subnet_network_security_group_association" "ise_func_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.ise_func_subnet.id
  network_security_group_id = azurerm_network_security_group.ise_func_subnet_nsg.id
}

resource "azurerm_subnet_nat_gateway_association" "azurerm_nat_gateway_ise_func_subnet_association" {
  nat_gateway_id = azurerm_nat_gateway.cisco_ise_nat_gateways.id
  subnet_id      = azurerm_subnet.ise_func_subnet.id
}