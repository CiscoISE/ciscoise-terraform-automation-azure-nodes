
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



# # Create a route table for public subnets
# resource "azurerm_route_table" "public_rt" {
#   name                = "PublicSubnetRouteTable"
#   location            = azurerm_virtual_network.cisco_ise.location
#   resource_group_name = azurerm_resource_group.cisco_ise_rg.name

#   route {
#     name                    = "PublicSubnetRoute"
#     address_prefix          = "0.0.0.0/0"   #"10.1.0.0/16"
#     next_hop_type           = "Internet"    #"VnetLocal" or "VirtualAppliance"
#     # next_hop_in_ip_address = "0.0.0.0"      #Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance #"10.10.1.1"
#   }
#   tags = {
#     Name = "PublicSubnetRouteTable"
#   }
# }

# # Associate all public subnets with the single route table
# resource "azurerm_subnet_route_table_association" "public_subnet_association" {
#   count           = length(azurerm_subnet.public_subnets)
#   subnet_id       = azurerm_subnet.public_subnets[count.index].id
#   route_table_id  = azurerm_route_table.public_rt.id
# }


# # Create a separate route table for each private subnet
# resource "azurerm_route_table" "private_rt" {
#   count              = length(var.private_subnet_cidrs)    #length(azurerm_subnet.private_subnets)
#   name               = "PrivateSubnetRouteTable-${count.index}"
#   resource_group_name = azurerm_resource_group.cisco_ise_rg.name
#   location           = azurerm_resource_group.cisco_ise_rg.location

#   tags = {
#     Name = "PrivateSubnetRouteTable-${count.index}"
#   }
# }

# # Associate each private subnet with its corresponding route table
# resource "azurerm_subnet_route_table_association" "private_subnet_association" {
#   count          = length(azurerm_subnet.private_subnets)
#   subnet_id      = azurerm_subnet.private_subnets[count.index].id
#   route_table_id = azurerm_route_table.private_rt[count.index].id
# }

resource "azurerm_subnet" "ise_func_subnet" {
  name                 = "ise_func_subnet"
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




# resource "azurerm_network_security_group" "ise_nsg" {
#   location            = "eastus"
#   name                = "prod_app_nsg-vm"
#   resource_group_name = var.ise_resource_group
#   security_rule = [
#     {
#       access                                     = "Allow"
#       description                                = ""
#       destination_address_prefix                 = "*"
#       destination_address_prefixes               = []
#       destination_application_security_group_ids = []
#       destination_port_range                     = "443"
#       destination_port_ranges                    = []
#       direction                                  = "Inbound"
#       name                                       = "prod_app_nsg-rule"
#       priority                                   = 100
#       protocol                                   = "Tcp"
#       source_address_prefix                      = "*"
#       source_address_prefixes                    = []
#       source_application_security_group_ids      = []
#       source_port_range                          = "*"
#       source_port_ranges                         = []
#     },
#   ]
#   tags = {
#     "refresh" = "test"
#   }
# }