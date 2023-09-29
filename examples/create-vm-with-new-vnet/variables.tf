variable "subscription" {
  type    = string
  default = "4af28428-fadd-42d1-ba1c-ba3eef6d4a6c"
}

variable "ise_resource_group" {
  type    = string
  default = "Cisco_ISE_RG"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "vnet_name" {
  type    = string
  default = "ise_vnet"
}

variable "ise_lb_subnet_name" {
  type    = string
  default = "ps-prod-snet-app1"
}

variable "ise_vm_subnet_name" {
  type    = string
  default = "ps-prod-snet-app2"
}


######################################################################################
#######################    Block to add ISE Nodes variable ###########################
######################################################################################


variable "ise_pan_node_names" {
  type    = list(string)
  default = ["ise-pan-primary", "ise-pan-secondary"]
}

variable "ise_psn_node_names" {
  type    = list(string)
  default = ["ise-psn-node-1", "ise-psn-node-2"]
}


######################################################################################
#######################    Block to add Loadbalancer variables #######################
######################################################################################


variable "ise_lb_name" {
  type    = string
  default = "ise-int-loadbalancer"
}

variable "ise_lb_sku" {
  type    = string
  default = "Standard"
}

variable "frontend_lb_ip_name" {
  type    = string
  default = "ise_lb_PrivateIPAddress"
}

variable "frontend_ip_allocation" {
  type    = string
  default = "Dynamic"
}

variable "ise_lb_backend_address_pool_name" {
  type    = string
  default = "ise-BackendAddressPool"
}


/* Virtual Machine Scale Set variables  */

variable "ise_publisher" {
  type    = string
  default = "cisco"
}

variable "ise_offer" {
  type    = string
  default = "cisco-ise-virtual"
}

variable "ise_plan_name" {
  type    = string
  default = "cisco-ise_3_2"
}

variable "ise_plan_product" {
  type    = string
  default = "cisco-ise-virtual"
}

variable "ise_image_sku" {
  type    = string
  default = "cisco-ise_3_2"
}

variable "ise_image_version" {
  type    = string
  default = "3.2.543"
}

variable "ise_vm_scaleset_name" {
  type    = string
  default = "ise-vm"
}

variable "ise_vm_size_sku" {
  type    = string
  default = "Standard_B2ms"
}

variable "ise_vm_vm_count" {
  type    = number
  default = 1
}

variable "ise_vm_adminuser_name" {
  type    = string
  default = "iseadmin"
}

variable "ise_vm_vm_storage_account_type" {
  type    = string
  default = "Premium_LRS"
}

variable "disk_size" {
  type    = number
  default = 600
}

variable "ise_vm_vm_sa_caching" {
  type    = string
  default = "ReadWrite"
}

variable "ise_vm_vm_nic_name" {
  type    = string
  default = "ise-vm-nic"
}


# Private DNS zone related info

variable "ise_vm_private_dns_zone_name" {
  type    = string
  default = "example.com"
}

variable "ise_vnet_dns_link_name" {
  type    = string
  default = "ise_vnet_dns_link"
}


# VNET and subnet cidr 

variable "vnet_address" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "ise_func_subnet_cidr" {
  description = "List of CIDR block for Funcation App private subnet"
  type        = list(string)
  default     = ["10.0.14.0/26"]
}


variable "marketplace_ise_image_agreement" {
  type    = bool
  default = false
}