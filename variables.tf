variable "subscription" {
  type    = string
  default = ""
}

variable "ise_resource_group" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = "East US"
}

variable "vnet_name" {
  type    = string
  default = ""
}

variable "ise_lb_subnet_name" {
  type    = string
  default = ""
}

variable "ise_vmss_subnet_name" {
  type    = string
  default = ""
}

variable "ise_lb_name" {
  type    = string
  default = "ise-int-LoadBalancer"
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
  default = "ise-vmss"
}

variable "ise_vm_size_sku" {
  type    = string
  default = "Standard_B2ms"
}

variable "ise_vmss_vm_count" {
  type    = number
  default = 1
}

variable "ise_vm_adminuser_name" {
  type    = string
  default = "iseadmin"
}

variable "ise_vmss_vm_storage_account_type" {
  type    = string
  default = "Premium_LRS"
}

variable "ise_vmss_vm_sa_caching" {
  type    = string
  default = "ReadWrite"
}

variable "ise_vmss_vm_nic_name" {
  type    = string
  default = "ise-vm-nic"
}

# Private DNS zone related info

variable "ise_vmss_private_dns_zone_name" {
  type    = string
  default = "example.com"
}

variable "ise_vnet_dns_link_name" {
  type    = string
  default = "ise_vnet_dns_link"
}