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

/* ISE Modules for setting up the ISE node infrastructure for Medium deployment. */

locals {
  roles_psn = compact(flatten([for vm in values(var.virtual_machines_psn) : split(", ", vm.roles) if vm.roles != null]))
  roles_pan = compact(flatten([for vm in values(var.virtual_machines_pan) : split(", ", vm.roles) if vm.roles != null]))
  roles_set = concat(local.roles_pan, local.roles_psn)
  roles     = local.roles_set
}

module "loadbalancer_dns" {
  source                           = "../../module/loadbalancer_dns"
  vnet_name                        = var.vnet_name
  location                         = var.location
  ise_resource_group               = var.ise_resource_group
  ise_lb_subnet_name               = var.ise_lb_subnet_name
  ise_func_subnet                  = var.ise_func_subnet
  ise_lb_name                      = var.ise_lb_name
  ise_lb_sku                       = var.ise_lb_sku
  frontend_ip_allocation           = var.frontend_ip_allocation
  frontend_lb_ip_name              = var.frontend_lb_ip_name
  ise_lb_backend_address_pool_name = var.ise_lb_backend_address_pool_name
  ise_vm_private_dns_zone_name     = var.dnsdomain
  ise_vm_adminuser_name            = var.ise_vm_adminuser_name
  password                         = var.password
  ise_vnet_dns_link_name           = var.ise_vnet_dns_link_name
  virtual_machines_pan             = var.virtual_machines_pan
  virtual_machines_psn             = var.virtual_machines_psn
  github_token                     = var.github_token
  github_repo                      = var.github_repo
  depends_on                       = [module.ise_pan_vm_cluster, module.ise_psn_vm_cluster]
}

module "ise_pan_vm_cluster" {
  source                          = "../../module/vm"
  for_each                        = var.virtual_machines_pan
  location                        = var.location
  vnet_name                       = var.vnet_name
  ise_vm_subnet_name              = var.ise_vm_subnet_name
  ise_resource_group              = var.ise_resource_group
  ise_node_names                  = [each.key]
  marketplace_ise_image_agreement = var.marketplace_ise_image_agreement
  ise_vm_size_sku                 = each.value.size
  disk_size                       = each.value.storage
  ise_vm_vm_sa_caching            = var.ise_vm_vm_sa_caching
  ise_vm_vm_storage_account_type  = var.ise_vm_vm_storage_account_type
  ise_image_sku                   = var.ise_image_sku
  ise_image_version               = var.ise_image_version
  ise_plan_name                   = var.ise_plan_name
  ise_plan_product                = var.ise_plan_product
  ise_offer                       = var.ise_offer
  ise_publisher                   = var.ise_publisher
  ise_vm_adminuser_name           = var.ise_vm_adminuser_name
  admin_ssh_public_key            = var.admin_ssh_key_path
  primarynameserver               = var.primarynameserver
  secondarynameserver             = var.secondarynameserver
  tertiarynameserver              = var.tertiarynameserver
  dnsdomain                       = var.dnsdomain
  ntpserver                       = var.ntpserver
  secondaryntpserver              = var.secondaryntpserver
  tertiaryntpserver               = var.tertiaryntpserver
  timezone                        = var.timezone
  password                        = var.password
  ersapi                          = var.ersapi
  openapi                         = var.openapi
  pxGrid                          = var.pxGrid
  pxgrid_cloud                    = var.pxgrid_cloud
  ise_node_zone                   = keys(var.virtual_machines_pan)
}

module "ise_psn_vm_cluster" {
  source                          = "../../module/vm"
  for_each                        = var.virtual_machines_psn
  location                        = var.location
  vnet_name                       = var.vnet_name
  ise_vm_subnet_name              = var.ise_vm_subnet_name
  ise_resource_group              = var.ise_resource_group
  ise_node_names                  = [each.key]
  marketplace_ise_image_agreement = var.marketplace_ise_image_agreement_psn
  ise_vm_size_sku                 = each.value.size
  disk_size                       = each.value.storage
  ise_vm_vm_sa_caching            = var.ise_vm_vm_sa_caching
  ise_vm_vm_storage_account_type  = var.ise_vm_vm_storage_account_type
  ise_image_sku                   = var.ise_image_sku
  ise_image_version               = var.ise_image_version
  ise_plan_name                   = var.ise_plan_name
  ise_plan_product                = var.ise_plan_product
  ise_offer                       = var.ise_offer
  ise_publisher                   = var.ise_publisher
  ise_vm_adminuser_name           = var.ise_vm_adminuser_name
  admin_ssh_public_key            = var.admin_ssh_key_path
  primarynameserver               = var.primarynameserver
  secondarynameserver             = var.secondarynameserver
  tertiarynameserver              = var.tertiarynameserver
  dnsdomain                       = var.dnsdomain
  ntpserver                       = var.ntpserver
  secondaryntpserver              = var.secondaryntpserver
  tertiaryntpserver               = var.tertiaryntpserver
  timezone                        = var.timezone
  password                        = var.password
  ersapi                          = var.ersapi
  openapi                         = var.openapi
  pxGrid                          = var.pxGrid
  pxgrid_cloud                    = var.pxgrid_cloud
  ise_node_zone                   = keys(var.virtual_machines_psn)
}


data "assert_test" "redundant_monitoring_values" {
  test  = length(flatten([for role in local.roles : role if role == "SecondaryMonitoring" || role == "SecondaryDedicatedMonitoring" || role == "PrimaryMonitoring" || role == "PrimaryDedicatedMonitoring"])) <= 1
  throw = "SecondaryMonitoring and SecondaryDedicatedMonitoring roles should be present in any one variable only once and not simultaneously in both variables"
}