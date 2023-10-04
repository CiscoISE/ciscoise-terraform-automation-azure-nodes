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
  default = "ps-prod-snet-app1"
}

variable "ise_vm_subnet_name" {
  type    = string
  default = "ps-prod-snet-app2"
}

variable "availability_zone" {
  type = string
  default = "1"
}

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

variable "count_value" {
  type    = number
  default = 3
}

variable "ise_node_names" {
  type    = list(string)
  default = []
}

# Userdata variables

variable "primarynameserver" {
  type    = string
  default = "168.63.129.16"
}

variable "dnsdomain" {
  type    = string
  default = "example.com"
}

variable "ntpserver" {
  type    = string
  default = "time.google.com"
}

variable "timezone" {
  type = string
  default = "UTC"
}

variable "password" {
  type    = string
  default = "C!sc0Ind1@"
}

variable "ersapi" {
  type    = string
  default = "yes"
}

variable "openapi" {
  type    = string
  default = "yes"
}

variable "pxGrid" {
  type    = string
  default = "yes"
}

variable "pxgrid_cloud" {
  type    = string
  default = "yes"
}

variable "marketplace_ise_image_agreement" {
  type = bool
  default = false
}