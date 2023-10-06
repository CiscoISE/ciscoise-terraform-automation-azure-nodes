######################################################################################
#######################     Block to add Azure variables   ###########################
######################################################################################

variable "subscription" {
  description = "Enter the Azure subscription ID"
  type        = string
  default     = "4af28428-fadd-42d1-ba1c-ba3eef6d4a6c"
}

variable "ise_resource_group" {
  description = "Mention the Resource Group name"
  type        = string
  default     = "Cisco_ISE_RG"
}

variable "location" {
  description = "Mention the region where you want to deploy resources"
  type        = string
  default     = "East US"
}


######################################################################################
#######################  Block for VNET related variables  ###########################
######################################################################################

variable "vnet_name" {
  type    = string
  default = "ise_vnet"
}

# variable "ise_lb_subnet_name" {
#   description = "Mention the subnet name for Loadbalancer"
#   type        = string
#   default     = "ps-prod-snet-app1"
# }

# variable "ise_vm_subnet_name" {
#   description = "Mention the subnet name for Virtual Machine/ ISE nodes"
#   type        = string
#   default     = "ps-prod-snet-app2"
# }

variable "ise_func_subnet" {
  description = "Mention the subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms."
  type        = string
  default     = "ise_func_subnet"
}

# VNET and subnet cidr 

variable "vnet_address" {
  description = "Enter the Virtual Network CIDR"
  type        = string
  default     = "10.0.0.0/16"
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


######################################################################################
#######################  Block for ISE Image related variables  ######################
######################################################################################

variable "ise_publisher" {
  description = "Name of the Image publisher"
  type        = string
  default     = "cisco"
}

variable "ise_offer" {
  description = "Image Offer"
  type        = string
  default     = "cisco-ise-virtual"
}

variable "ise_plan_name" {
  description = "Plan Name for using the Marketplace ISE image, available options - cisco-ise_3_2 & cisco-ise_3_3"
  type        = string
  default     = "cisco-ise_3_2"
}

variable "ise_plan_product" {
  description = "Value of Image Offer for using inside VM resource plan block"
  type        = string
  default     = "cisco-ise-virtual"
}

variable "ise_image_sku" {
  description = "ISE image sku - available values -  cisco-ise_3_2 & cisco-ise_3_3 "
  type        = string
  default     = "cisco-ise_3_2"
}

variable "ise_image_version" {
  description = "ISE image version - available versions: 3.2.543 & 3.3.430 "
  type        = string
  default     = "3.2.543"
}

variable "marketplace_ise_image_agreement" {
  description = "If ISE marketplace image agreement is already done set the value to 'true' else set it as 'false'. You can check the status by executing the Azure CLI command - 'az vm image terms show --publisher cisco  --offer cisco-ise-virtual --plan cisco-ise_3_2' "
  type        = bool
  default     = false
}

variable "marketplace_ise_image_agreement_psn" {
  description = "If ISE marketplace image agreement is already done set the value to 'true' else set it as 'false'. You can check the status by executing the Azure CLI command - 'az vm image terms show --publisher cisco  --offer cisco-ise-virtual --plan cisco-ise_3_2' "
  type        = bool
  default     = true
}


######################################################################################
################ Block for ISE VirtualMachine related variables  #####################
######################################################################################

variable "ise_vm_size_sku" {
  description = "Mention the Virtual Machine size as per the ISE recommendations - https://www.cisco.com/c/en/us/td/docs/security/ise/ISE_on_Cloud/b_ISEonCloud/m_ISEonAzureServices.html "
  type        = string
  default     = "Standard_B2ms"
}

variable "ise_vm_size_sku_psn" {
  description = "Mention the Virtual Machine size as per the ISE recommendations - https://www.cisco.com/c/en/us/td/docs/security/ise/ISE_on_Cloud/b_ISEonCloud/m_ISEonAzureServices.html "
  type        = string
  default     = "Standard_B2ms"
}

variable "disk_size" {
  description = "ISE node disk size"
  type        = number
  default     = 600
}

variable "ise_vm_adminuser_name" {
  description = "ISE admin username"
  type        = string
  default     = "iseadmin"
}

variable "ise_vm_vm_storage_account_type" {
  description = "Disk storage type"
  type        = string
  default     = "Premium_LRS"
}

variable "ise_vm_vm_sa_caching" {
  type    = string
  default = "ReadWrite"
}

variable "availability_zone_pan" {
  type    = string
  default = "1"
}

variable "availability_zone_psn" {
  type    = string
  default = "2"
}

variable "admin_ssh_key_path" {
  type        = string
  description = "Path to the SSH public key file"
  default     = "isekey.pub" # path to public key
}

######################################################################################
################ Block for ISE Nodes Hostname related variables  #####################
######################################################################################


variable "ise_pan_node_names" {
  description = "Mention the hostname for ISE PAN Primary and Secondary nodes"
  type        = list(string)
  default     = ["ise-pan-primary", "ise-pan-secondary"]
}

variable "ise_psn_node_names" {
  description = "Mention the hostname for ISE PSN nodes "
  type        = list(string)
  default     = ["ise-psn-node-1", "ise-psn-node-2"]
}


######################################################################################
############## Block for ISE Internal Loadbalancer related variables  ################
######################################################################################


variable "ise_lb_name" {
  description = "Provide the Loadbalancer name"
  type        = string
  default     = "ise-int-loadbalancer"
}

variable "ise_lb_sku" {
  description = "Mention the Loadbalancer SKU"
  type        = string
  default     = "Standard"
}

variable "frontend_lb_ip_name" {
  description = "Mention the Frontend IP address name"
  type        = string
  default     = "ise_lb_PrivateIPAddress"
}

variable "frontend_ip_allocation" {
  description = "Mention the Frontend Private IP address allocation type - Static or Dynamic"
  type        = string
  default     = "Dynamic"
}

variable "ise_lb_backend_address_pool_name" {
  description = "Mention the name for ISE Loadbalancer backend pool"
  type        = string
  default     = "ise-BackendAddressPool"
}


######################################################################################
################ Block for ISE Private DNS zone related variables  ###################
######################################################################################


# variable "ise_vm_private_dns_zone_name" {
#   description = "Provide the name for ISE Private DNS zone "
#   type        = string
#   default     = "example.com"
# }

variable "ise_vnet_dns_link_name" {
  description = "Provide the name for VNET link to associate with the Provide DNS zone"
  type        = string
  default     = "ise_vnet_dns_link"
}

variable "github_token" {
  description = "This token will be used to read the Github code having Repo and Workflow access"
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "Enter the Github URL of the repo hosting the Function App code"
  type        = string
  default     = ""
}

######################################################################################
##################### Block for ISE Node Userdata variables  #########################
######################################################################################

# Userdata variables

variable "primarynameserver" {
  description = "Enter the IP address of the primary name server. Only IPv4 addresses are supported"
  type        = string
  default     = "168.63.129.16"
}

variable "dnsdomain" {
  description = "Enter the FQDN of the DNS domain. The entry can contain ASCII characters, numerals, hyphens (-), and periods (.)."
  type        = string
  default     = "example.com"
}

variable "ntpserver" {
  description = "Enter the IPv4 address or FQDN of the NTP server that must be used for synchronization, for example, time.nist.gov."
  type        = string
  default     = "time.google.com"
}

variable "timezone" {
  description = "Enter a timezone, for example, Etc/UTC. We recommend that you set all the Cisco ISE nodes to the Coordinated Universal Time (UTC) timezone"
  type        = string
  default     = "UTC"
}

# This is a dummy password, we highly recommend to change it after configuration
variable "password" {
  description = "Configure a password for GUI-based login to Cisco ISE. The password that you enter must comply with the Cisco ISE password policy. The password must contain 6 to 25 characters and include at least one numeral, one uppercase letter, and one lowercase letter. The password cannot be the same as the username or its reverse (iseadmin or nimdaesi), cisco, or ocsic. The allowed special characters are @~*!,+=_-."
  type        = string
  default     = "C!sc0Ind1@"
}

variable "ersapi" {
  description = "Enter yes to enable ERS, or no to disallow ERS."
  type        = string
  default     = "yes"
}

variable "openapi" {
  description = "Enter yes to enable OpenAPI, or no to disallow OpenAPI."
  type        = string
  default     = "yes"
}

variable "pxGrid" {
  description = "Enter yes to enable pxGrid, or no to disallow pxGrid"
  type        = string
  default     = "yes"
}

variable "pxgrid_cloud" {
  description = "Enter yes to enable pxGrid Cloud or no to disallow pxGrid Cloud. To enable pxGrid Cloud, you must enable pxGrid. If you disallow pxGrid, but enable pxGrid Cloud, pxGrid Cloud services are not enabled on launch."
  type        = string
  default     = "yes"
}