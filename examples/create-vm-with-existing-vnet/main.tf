/* ISE Modules for setting up the ISE node infrastructure for Medium deployment. */

module "loadbalancer_dns" {
  source                       = "../../module/loadbalancer_dns"
  vnet_name                    = var.vnet_name #module.ise_vnet.vnet_name
  ise_resource_group           = var.ise_resource_group
  ise_lb_subnet_name           = var.ise_lb_subnet_name #module.ise_vnet.ise_lb_subnet_name
  ise_func_subnet              = var.ise_func_subnet    #module.ise_vnet.ise_func_subnet
  ise_node_names               = concat(var.ise_psn_node_names, var.ise_pan_node_names)
  ise_pan_node_names           = var.ise_pan_node_names
  ise_vm_private_dns_zone_name = var.dnsdomain
  github_token                 = var.github_token
  github_repo                  = var.github_repo

  depends_on = [module.ise_pan_vm_cluster, module.ise_psn_vm_cluster]
}

module "ise_pan_vm_cluster" {
  source                          = "../../module/vm"
  location                        = var.location
  vnet_name                       = var.vnet_name          #module.ise_vnet.vnet_name
  ise_lb_subnet_name              = var.ise_lb_subnet_name #module.ise_vnet.ise_lb_subnet_name
  ise_vm_subnet_name              = var.ise_vm_subnet_name #module.ise_vnet.ise_vm_subnet_name
  ise_resource_group              = var.ise_resource_group
  ise_node_names                  = var.ise_pan_node_names
  marketplace_ise_image_agreement = var.marketplace_ise_image_agreement
  ise_vm_size_sku                 = var.ise_vm_size_sku
  disk_size                       = var.disk_size
  ise_image_sku                   = var.ise_image_sku
  ise_image_version               = var.ise_image_version
  ise_plan_name                   = var.ise_plan_name
  admin_ssh_public_key            = var.admin_ssh_key_path
  availability_zone               = var.availability_zone_pan
  primarynameserver               = var.primarynameserver
  dnsdomain                       = var.dnsdomain
  ntpserver                       = var.ntpserver
  timezone                        = var.timezone
  password                        = var.password
  ersapi                          = var.ersapi
  openapi                         = var.openapi
  pxGrid                          = var.pxGrid
  pxgrid_cloud                    = var.pxgrid_cloud

  #depends_on = [module.ise_vnet]
}

module "ise_psn_vm_cluster" {
  source                          = "../../module/vm"
  location                        = var.location
  vnet_name                       = var.vnet_name          #module.ise_vnet.vnet_name
  ise_lb_subnet_name              = var.ise_lb_subnet_name #module.ise_vnet.ise_lb_subnet_name
  ise_vm_subnet_name              = var.ise_vm_subnet_name #module.ise_vnet.ise_vm_subnet_name
  ise_resource_group              = var.ise_resource_group
  ise_node_names                  = var.ise_psn_node_names
  marketplace_ise_image_agreement = var.marketplace_ise_image_agreement_psn
  ise_vm_size_sku                 = var.ise_vm_size_sku_psn
  disk_size                       = var.disk_size
  ise_image_sku                   = var.ise_image_sku
  ise_image_version               = var.ise_image_version
  ise_plan_name                   = var.ise_plan_name
  admin_ssh_public_key            = var.admin_ssh_key_path
  availability_zone               = var.availability_zone_psn
  primarynameserver               = var.primarynameserver
  dnsdomain                       = var.dnsdomain
  ntpserver                       = var.ntpserver
  timezone                        = var.timezone
  password                        = var.password
  ersapi                          = var.ersapi
  openapi                         = var.openapi
  pxGrid                          = var.pxGrid
  pxgrid_cloud                    = var.pxgrid_cloud

  # depends_on = [module.ise_vnet]
}