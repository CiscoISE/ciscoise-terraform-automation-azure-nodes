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

# output "pan_private_ip_address" {
#   value = module.ise_pan_vm_cluster.private_address
# }

output "pan_ip" {
  value = [for private_ip in module.ise_pan_vm_cluster : private_ip.private_address]

}

output "psn_ip" {
  value = [for private_ip in module.ise_psn_vm_cluster : private_ip.private_address]

}

output "pan_name" {
  value = [for pan_name in module.ise_pan_vm_cluster : pan_name.node_name]
}

output "psn_name" {
  value = [for psn_name in module.ise_psn_vm_cluster : psn_name.node_name]
}

output "private_dns_records" {
  value = module.loadbalancer_dns.private_dns_records
}

output "loadbalancer_frontendIP" {
  value = module.loadbalancer_dns.loadbalancer_frontendIP
}