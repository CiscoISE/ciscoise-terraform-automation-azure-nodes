locals {
  ise_pan_node_names = keys(var.virtual_machines_pan)
  ise_psn_node_names = keys(var.virtual_machines_psn)

  # roles_pan = flatten([for vm in values(var.virtual_machines_pan) : vm.roles != null ? [vm.roles] : []])
  # roles_psn = flatten([for vm in values(var.virtual_machines_psn) : vm.roles != null ? [vm.roles] : []])
  roles_psn = compact(flatten([for vm in values(var.virtual_machines_psn) : split(", ", vm.roles) if vm.roles != null]))
  roles_pan = compact(flatten([for vm in values(var.virtual_machines_pan) : split(", ", vm.roles) if vm.roles != null]))
  roles_set = concat(local.roles_pan, local.roles_psn)
  roles     = local.roles_set
}


module "ise_vnet" {
  source               = "git@github3.cisco.com:techops-operation/ise_launch_template-terraform-azure-vnet.git//modules/vnet"
  location             = var.location
  vnet_name            = var.vnet_name
  ise_resource_group   = var.ise_resource_group
  vnet_address         = var.vnet_address
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  ise_func_subnet_cidr = var.ise_func_subnet_cidr
  ise_func_subnet      = var.ise_func_subnet
}

module "loadbalancer_dns" {
  source                           = "../../module/loadbalancer_dns"
  vnet_name                        = module.ise_vnet.vnet_name
  location                         = var.location
  ise_resource_group               = var.ise_resource_group
  ise_lb_subnet_name               = module.ise_vnet.ise_lb_subnet_name
  ise_func_subnet                  = module.ise_vnet.ise_func_subnet
  ise_node_names                   = concat(local.ise_psn_node_names, local.ise_pan_node_names)
  ise_lb_name                      = var.ise_lb_name
  ise_lb_sku                       = var.ise_lb_sku
  frontend_ip_allocation           = var.frontend_ip_allocation
  frontend_lb_ip_name              = var.frontend_lb_ip_name
  ise_lb_backend_address_pool_name = var.ise_lb_backend_address_pool_name
  ise_pan_node_names               = local.ise_pan_node_names
  ise_psn_node_names               = local.ise_psn_node_names
  ise_vm_private_dns_zone_name     = var.dnsdomain
  ise_vm_adminuser_name            = var.ise_vm_adminuser_name
  password                         = var.password
  ise_vnet_dns_link_name           = var.ise_vnet_dns_link_name
  virtual_machines_pan             = var.virtual_machines_pan
  virtual_machines_psn             = var.virtual_machines_psn
  github_token                     = var.github_token
  github_repo                      = var.github_repo
  # ise_vm_nic = module.ise_pan_vm_cluster.ise_vm_nic
  depends_on = [module.ise_vnet, module.ise_pan_vm_cluster, module.ise_psn_vm_cluster]
}

module "ise_pan_vm_cluster" {
  source                          = "../../module/vm"
  for_each                        = var.virtual_machines_pan
  location                        = var.location
  vnet_name                       = module.ise_vnet.vnet_name
  ise_vm_subnet_name              = module.ise_vnet.ise_vm_subnet_name
  ise_resource_group              = var.ise_resource_group
  ise_node_names                  = [each.key] #var.ise_pan_node_names
  marketplace_ise_image_agreement = var.marketplace_ise_image_agreement
  ise_vm_size_sku                 = each.value.size    #var.ise_vm_size_sku
  disk_size                       = each.value.storage #var.disk_size
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
  dnsdomain                       = var.dnsdomain
  ntpserver                       = var.ntpserver
  timezone                        = var.timezone
  password                        = var.password
  ersapi                          = var.ersapi
  openapi                         = var.openapi
  pxGrid                          = var.pxGrid
  pxgrid_cloud                    = var.pxgrid_cloud

  ise_node_zone = local.ise_pan_node_names

  depends_on = [module.ise_vnet]
}

module "ise_psn_vm_cluster" {
  source                          = "../../module/vm"
  for_each                        = var.virtual_machines_psn
  location                        = var.location
  vnet_name                       = module.ise_vnet.vnet_name
  ise_vm_subnet_name              = module.ise_vnet.ise_vm_subnet_name
  ise_resource_group              = var.ise_resource_group
  ise_node_names                  = [each.key] #var.ise_psn_node_names
  marketplace_ise_image_agreement = var.marketplace_ise_image_agreement_psn
  ise_vm_size_sku                 = each.value.size    #var.ise_vm_size_sku_psn
  disk_size                       = each.value.storage #var.disk_size_psn
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
  dnsdomain                       = var.dnsdomain
  ntpserver                       = var.ntpserver
  timezone                        = var.timezone
  password                        = var.password
  ersapi                          = var.ersapi
  openapi                         = var.openapi
  pxGrid                          = var.pxGrid
  pxgrid_cloud                    = var.pxgrid_cloud

  ise_node_zone = local.ise_psn_node_names

  depends_on = [module.ise_vnet]
}




data "assert_test" "redundant_monitoring_values" {
  test  = length(flatten([for role in local.roles : role if role == "SecondaryMonitoring" || role == "SecondaryDedicatedMonitoring" || role == "PrimaryMonitoring" || role == "PrimaryDedicatedMonitoring"])) <= 1
  throw = "SecondaryMonitoring and SecondaryDedicatedMonitoring roles should be present in any one variable only once and not simultaneously in both variables"
}

