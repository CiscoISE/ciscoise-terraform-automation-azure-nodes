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

output "ise-vm-backendpool" {
  value = azurerm_lb_backend_address_pool.ise-vm-backendpool[*].id
}

# output "ise_vm_private_dns_zone" {
#   value = azurerm_virtual_machine.ise_vm_nic_ip[*].private_ip_address
# }


output "private_dns_records" {
  value = [for ise_fqdn in azurerm_private_dns_a_record.ise_vm_dns_record : ise_fqdn.fqdn]
}

# output "node_name" {
#   value = [ for node_name in azurerm_linux_virtual_machine.ise_vm : node_name.name ]
# }

output "loadbalancer_frontendIP" {
  value = azurerm_lb.ise-lb[*].private_ip_address
}