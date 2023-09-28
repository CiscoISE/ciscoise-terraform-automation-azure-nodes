
module "ise_vnet" {
  source               = "git::ssh://github3.cisco.com/techops-operation/ise_launch_template-terraform-azure-vnet.git//modules/vnet?ref=rohit-vnet"
  location             = var.location
  vnet_name            = var.vnet_name
  ise_resource_group   = var.ise_resource_group
  vnet_address         = var.vnet_address
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  ise_func_subnet_cidr = var.ise_func_subnet_cidr
}

module "loadbalancer_dns" {
  source                       = "../../module/loadbalancer_dns"
  vnet_name                    = module.ise_vnet.vnet_name
  ise_resource_group           = var.ise_resource_group
  ise_lb_subnet_name           = module.ise_vnet.ise_lb_subnet_name
  ise_func_subnet              = module.ise_vnet.ise_func_subnet
  ise_node_names               = concat(var.ise_psn_node_names, var.ise_pan_node_names)
  ise_pan_node_names           = var.ise_pan_node_names
  ise_vm_private_dns_zone_name = var.ise_vm_private_dns_zone_name
  # ise_vm_nic = module.ise_pan_vm_cluster.ise_vm_nic
  depends_on = [module.ise_vnet, module.ise_pan_vm_cluster, module.ise_psn_vm_cluster]
}

module "ise_pan_vm_cluster" {
  source                          = "../../module/vm"
  location                        = var.location
  vnet_name                       = module.ise_vnet.vnet_name
  ise_lb_subnet_name              = module.ise_vnet.ise_lb_subnet_name
  ise_vm_subnet_name              = module.ise_vnet.ise_vm_subnet_name
  ise_resource_group              = var.ise_resource_group
  ise_node_names                  = var.ise_pan_node_names
  marketplace_ise_image_agreement = var.marketplace_ise_image_agreement
  ise_vm_size_sku                 = var.ise_vm_size_sku
  disk_size                       = var.disk_size
  ise_image_sku                   = var.ise_image_sku
  ise_image_version               = var.ise_image_version
  ise_plan_name                   = var.ise_plan_name

  depends_on = [module.ise_vnet]
}

module "ise_psn_vm_cluster" {
  source                          = "../../module/vm"
  location                        = var.location
  vnet_name                       = module.ise_vnet.vnet_name
  ise_lb_subnet_name              = module.ise_vnet.ise_lb_subnet_name
  ise_vm_subnet_name              = module.ise_vnet.ise_vm_subnet_name
  ise_resource_group              = var.ise_resource_group
  ise_node_names                  = var.ise_psn_node_names
  marketplace_ise_image_agreement = var.marketplace_ise_image_agreement
  ise_vm_size_sku                 = var.ise_vm_size_sku
  disk_size                       = var.disk_size
  ise_image_sku                   = var.ise_image_sku
  ise_image_version               = var.ise_image_version
  ise_plan_name                   = var.ise_plan_name

  depends_on = [module.ise_vnet]
}