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

output "resource_group" {
  value = azurerm_resource_group.cisco_ise_rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.cisco_ise.name
}

output "ise_lb_subnet_name" {
  value = azurerm_subnet.private_subnets[0].name
}

output "ise_vm_subnet_name" {
  value = azurerm_subnet.private_subnets[1].name
}

# output "ise_func_subnet_name" {
#   value = azurerm_subnet.private_subnets[2].name
# }

output "public_subnet_ids" {
  value = azurerm_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = azurerm_subnet.private_subnets[*].id
}

output "public_nsg_ids" {
  value = azurerm_network_security_group.cisco_ise_public_nsg[*].id
}

output "private_nsg_ids" {
  value = azurerm_network_security_group.cisco_ise_private_nsg[*].id
}

output "public_ip_ids" {
  value = azurerm_public_ip.cisco_ise_public_ips[*].id
}

output "nat_gateway_ids" {
  value = azurerm_nat_gateway.cisco_ise_nat_gateways[*].id
}

output "ise_func_subnet" {
  value = azurerm_subnet.ise_func_subnet.name
}