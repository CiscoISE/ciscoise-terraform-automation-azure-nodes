######################################################################################
#######################     Block to add Azure variables   ###########################
######################################################################################

variable "subscription" {
  description = "Enter the Azure subscription ID"
  type        = string
  default     = ""
}

variable "ise_resource_group" {
  description = "Enter the Resource Group name"
  type        = string
  default     = ""
}

variable "location" {
  description = "Enter the region where you want to deploy resources"
  type        = string
  default     = ""
}


######################################################################################
##################  Block to add Virtual Machine Network variables  ##################
######################################################################################

variable "vnet_name" {
  description = "Enter the Virtual Network (VNET) name"
  type        = string
  default     = ""
}

variable "ise_lb_subnet_name" {
  description = "Enter the subnet name for Loadbalancer"
  type        = string
  default     = ""
}

variable "ise_vm_subnet_name" {
  description = "Enter the subnet name for Virtual Machine/ ISE nodes"
  type        = string
  default     = ""
}


######################################################################################
##################   Block to add ISE Image related variables   ######################
######################################################################################


variable "ise_publisher" {
  description = "Enter ISE Image publisher name"
  type        = string
  default     = ""
}

variable "ise_offer" {
  description = "Enter the ISE Image offer name"
  type        = string
  default     = ""
}

variable "ise_plan_name" {
  description = "Enter the ISE Image billing plan name"
  type        = string
  default     = ""
}

variable "ise_plan_product" {
  description = "Enter the ISE Image plan's product name, required for Virtual Machine Image plan"
  type        = string
  default     = ""
}

variable "ise_image_sku" {
  description = "Enter ISE Image sku name"
  type        = string
  default     = ""
}

variable "ise_image_version" {
  description = "Enter the ISE Image sku version"
  type        = string
  default     = ""
}

variable "marketplace_ise_image_agreement" {
  description = "Accept Azure Marketplace term so that the image can be used to create VMs."
  type        = bool
}


######################################################################################
#############   Block to add ISE Virtual Machine  related variables   ################
######################################################################################

variable "ise_node_names" {
  description = "Enter the desired number of ISE Virtual Machine hostname in a list separated by comma"
  type        = list(string)
  default     = []
}

variable "ise_node_zone" {
  description = "Setting the different zone for each VM"
  type        = list(string)
  default     = []
}

variable "ise_vm_size_sku" {
  description = "Enter the Virtual Machine size sku"
  type        = string
  default     = ""
}

variable "ise_vm_adminuser_name" {
  description = "Enter the ISE admin username"
  type        = string
  default     = ""
}

variable "admin_ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "ise_vm_vm_storage_account_type" {
  description = "Virtual Machine disk storage type"
  type        = string
  default     = ""
}

variable "disk_size" {
  description = "Enter the Virtual Machine disk size"
  type        = number
}

variable "ise_vm_vm_sa_caching" {
  description = "Cache setting is set to Read/Write for OS disk"
  type        = string
  default     = ""
}


######################################################################################
#############   Block to add ISE Virtual Machine Userdata variables   ################
######################################################################################

variable "primarynameserver" {
  description = "Enter the IP address of the primary name server. Only IPv4 addresses are supported"
  type        = string
  default     = ""
}

variable "dnsdomain" {
  description = "Enter the FQDN of the DNS domain. The entry can contain ASCII characters, numerals, hyphens (-), and periods (.)."
  type        = string
  default     = ""
}

variable "ntpserver" {
  description = "Enter the IPv4 address or FQDN of the NTP server that must be used for synchronization, for example, time.nist.gov."
  type        = string
  default     = ""
}

variable "timezone" {
  description = "Enter a timezone, for example, Etc/UTC. We recommend that you set all the Cisco ISE nodes to the Coordinated Universal Time (UTC) timezone"
  type        = string
  default     = ""
}

variable "password" {
  description = "Configure a password for GUI-based login to Cisco ISE. The password that you enter must comply with the Cisco ISE password policy. The password must contain 6 to 25 characters and include at least one numeral, one uppercase letter, and one lowercase letter. The password cannot be the same as the username or its reverse (iseadmin or nimdaesi), cisco, or ocsic. The allowed special characters are @~*!,+=_-."
  type        = string
  default     = ""
}

variable "ersapi" {
  description = "Enter yes to enable ERS, or no to disallow ERS."
  type        = string
  default     = ""
}

variable "openapi" {
  description = "Enter yes to enable OpenAPI, or no to disallow OpenAPI."
  type        = string
  default     = ""
}

variable "pxGrid" {
  description = "Enter yes to enable pxGrid, or no to disallow pxGrid"
  type        = string
  default     = ""
}

variable "pxgrid_cloud" {
  description = "Enter yes to enable pxGrid Cloud or no to disallow pxGrid Cloud. To enable pxGrid Cloud, you must enable pxGrid. If you disallow pxGrid, but enable pxGrid Cloud, pxGrid Cloud services are not enabled on launch."
  type        = string
  default     = ""
}
