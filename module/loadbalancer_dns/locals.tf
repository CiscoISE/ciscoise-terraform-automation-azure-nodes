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

locals {
  appConIP                  = var.appConIP
  pan_node                  = keys(var.virtual_machines_pan)
  psn_node                  = keys(var.virtual_machines_psn)
  ise_node_name             = concat(local.pan_node, local.psn_node)
  combined_key_value        = zipmap(local.appConIP, local.pan_node)
  appConfqdn                = var.appConfqdn
  combined_pan_kv_fqdn      = zipmap(local.appConfqdn, local.pan_node)
  combined_psn_kv_fqdn      = zipmap(local.psn_node, local.psn_node)
  username_password_key     = var.username_password_key
  username_password_value   = [var.ise_vm_adminuser_name, var.password]
  combined_user_password_kv = zipmap(local.username_password_key, local.username_password_value)
  create_nlb                = anytrue(flatten([for vm in [var.virtual_machines_pan, var.virtual_machines_psn] : [for instance, details in vm : details.enable_nlb]]))
  combined_nodes            = merge(var.virtual_machines_pan, var.virtual_machines_psn)
  enabled_nodes             = [for vm_name, vm_attribute in local.combined_nodes : vm_name if vm_attribute.enable_nlb == true]
}