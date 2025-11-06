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

######################################################################################
#######################     Block to add Azure variables   ###########################
######################################################################################

variable "subscription" {
  description = "Enter the Azure subscription ID"
  type        = string
  default     = ""
}

variable "ise_resource_group" {
  description = "Mention the Resource Group name"
  type        = string
  default     = ""
}

variable "location" {
  description = "Mention the region where you want to deploy resources"
  type        = string
  default     = ""
}


######################################################################################
################### Block for Virtual Network related variables  #####################
######################################################################################

variable "vnet_name" {
  type    = string
  default = ""
}

variable "ise_func_subnet" {
  description = "Mention the subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms."
  type        = string
  default     = ""
}

# VNET and subnet cidr 

variable "vnet_address" {
  description = "Enter the Virtual Network CIDR"
  type        = string
  default     = ""
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "ise_func_subnet_cidr" {
  description = "List of CIDR block for Funcation App private subnet"
  type        = list(string)
  default     = []
}


######################################################################################
#######################  Block for ISE Image related variables  ######################
######################################################################################

variable "ise_publisher" {
  description = "Name of the Image publisher"
  type        = string
  default     = ""
}

variable "ise_offer" {
  description = "Image Offer"
  type        = string
  default     = ""
}

variable "ise_plan_name" {
  description = "Plan Name for using the Marketplace ISE image, available options - cisco-ise_3_2, cisco-ise_3_3 & cisco-ise_3_4"
  type        = string
  default     = ""
}

variable "ise_plan_product" {
  description = "Value of Image Offer for using inside VM resource plan block"
  type        = string
  default     = ""
}

variable "ise_image_sku" {
  description = "ISE image sku - available values -  cisco-ise_3_2, cisco-ise_3_3 & cisco-ise_3_4 "
  type        = string
  default     = ""
}

variable "ise_image_version" {
  description = "ISE image version - available versions: 3.2.543, 3.3.430 & 3.4.608 "
  type        = string
  default     = ""
}

variable "marketplace_ise_image_agreement" {
  description = "If ISE marketplace image agreement is already done set the value to 'true' else set it as 'false'. You can check the status by executing the Azure CLI command - 'az vm image terms show --publisher cisco  --offer cisco-ise-virtual --plan cisco-ise_3_2' "
  type        = bool
}

variable "marketplace_ise_image_agreement_psn" {
  description = "If ISE marketplace image agreement is already done set the value to 'true' else set it as 'false'. You can check the status by executing the Azure CLI command - 'az vm image terms show --publisher cisco  --offer cisco-ise-virtual --plan cisco-ise_3_2' "
  type        = bool
  default     = true
}


######################################################################################
################ Block for ISE VirtualMachine related variables  #####################
######################################################################################

# variable "ise_vm_size_sku" {
#   description = "Mention the Virtual Machine size as per the ISE recommendations - https://www.cisco.com/c/en/us/td/docs/security/ise/ISE_on_Cloud/b_ISEonCloud/m_ISEonAzureServices.html "
#   type        = string
#   default     = ""
# }

# variable "ise_vm_size_sku_psn" {
#   description = "Mention the Virtual Machine size as per the ISE recommendations - https://www.cisco.com/c/en/us/td/docs/security/ise/ISE_on_Cloud/b_ISEonCloud/m_ISEonAzureServices.html "
#   type        = string
#   default     = ""
# }

# variable "disk_size" {
#   description = "ISE node disk size"
#   type        = number
# }

# variable "disk_size_psn" {
#   description = "ISE Virtual Machine disk size"
#   type        = number
# }

variable "ise_vm_adminuser_name" {
  description = "ISE admin username"
  type        = string
  default     = ""
}

variable "ise_vm_vm_storage_account_type" {
  description = "Disk storage type"
  type        = string
  default     = ""
}

variable "ise_vm_vm_sa_caching" {
  type    = string
  default = ""
}


variable "admin_ssh_key_path" {
  type        = string
  description = "Path to the SSH public key file"
  default     = "" # path to public key
}

######################################################################################
################ Block for ISE Nodes Hostname related variables  #####################
######################################################################################


variable "ise_pan_node_names" {
  description = "Mention the hostname for ISE PAN Primary and Secondary nodes"
  type        = list(string)
  default     = []
}

variable "ise_psn_node_names" {
  description = "Mention the hostname for ISE PSN nodes "
  type        = list(string)
  default     = []
}


######################################################################################
############## Block for ISE Internal Loadbalancer related variables  ################
######################################################################################


variable "ise_lb_name" {
  description = "Provide the Loadbalancer name"
  type        = string
  default     = ""
}

variable "ise_lb_sku" {
  description = "Mention the Loadbalancer SKU"
  type        = string
  default     = ""
}

variable "frontend_lb_ip_name" {
  description = "Mention the Frontend IP address name"
  type        = string
  default     = ""
}

variable "frontend_ip_allocation" {
  description = "Mention the Frontend Private IP address allocation type - Static or Dynamic"
  type        = string
  default     = ""
}

variable "ise_lb_backend_address_pool_name" {
  description = "Mention the name for ISE Loadbalancer backend pool"
  type        = string
  default     = ""
}


######################################################################################
################ Block for ISE Private DNS zone related variables  ###################
######################################################################################


variable "ise_vnet_dns_link_name" {
  description = "Provide the name for VNET link to associate with the Provide DNS zone"
  type        = string
  default     = ""
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
  default     = ""
  
  validation {
    condition     = var.primarynameserver != null && var.primarynameserver != ""
    error_message = "The primarynameserver variable must be defined and cannot be empty. Please provide a valid IP address for the primary name server."
  }
}

variable "secondarynameserver" {
  description = "Enter the IP address of the secondary name server (optional). Only IPv4 addresses are supported."
  type        = string
  default     = ""
}

variable "tertiarynameserver" {
  description = "Enter the IP address of the tertiary name server (optional). Only IPv4 addresses are supported."
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
  
  validation {
    condition     = var.ntpserver != null && var.ntpserver != ""
    error_message = "The ntpserver variable must be defined and cannot be empty. Please provide a valid IP address or FQDN for the NTP server."
  }
}

variable "secondaryntpserver" {
  description = "Enter the IPv4 address or FQDN of the secondary NTP server (optional)"
  type        = string
  default     = ""
}

variable "tertiaryntpserver" {
  description = "Enter the IPv4 address or FQDN of the tertiary NTP server (optional)"
  type        = string
  default     = ""
}

variable "timezone" {
  description = "Enter a timezone, for example, Etc/UTC. We recommend that you set all the Cisco ISE nodes to the Coordinated Universal Time (UTC) timezone"
  type        = string
  default     = ""
}

# This is a dummy password, we highly recommend to change it after configuration
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


variable "virtual_machines_pan" {
  description = <<-EOT
  Specify the configuration for pan instance. It should follow below format where key is the hostname and values are instance attributes.
  {
    <hostname> = {
      size = "<vm_size>",
      storage = "<storage_size>",
      services =  "<service_1>,<service_2>",
      roles = "<role_1>,<role_2>"
    }
  }
  EOT
  type = map(object({
    size     = string
    storage  = number
    services = optional(string)
    roles    = optional(string, "SecondaryAdmin")
  }))

  validation {
    condition     = length(flatten([for vm in values(var.virtual_machines_pan) : [for role in split(", ", vm.roles) : role if role != "SecondaryAdmin" && role != "SecondaryMonitoring" && role != "PrimaryMonitoring"]])) == 0
    error_message = "Roles can only accept 'PrimaryMonitoring or SecondaryMonitoring' and 'SecondaryAdmin' values."
  }

}

variable "virtual_machines_psn" {
  description = <<-EOT
  Specify the configuration for PSN instance. It should follow below format where key is the hostname and values are instance attributes.
  {
    <hostname> = {
      size = "<vm_size>",
      storage = "<storage_size>",
      services =  "<service_1>,<service_2>",
      roles = "<MnT_role>"
    }
  }
  EOT
  type = map(object({
    size     = string
    storage  = number
    services = optional(string)
    roles    = optional(string)
  }))

  validation {
    condition     = length([for vm in values(var.virtual_machines_psn) : vm.roles if vm.roles != null && (vm.roles != "SecondaryMonitoring" && vm.roles != "SecondaryDedicatedMonitoring" && vm.roles != "PrimaryMonitoring" && vm.roles != "PrimaryDedicatedMonitoring")]) == 0
    error_message = "Roles can only accept one of the value from 'SecondaryMonitoring', 'SecondaryDedicatedMonitoring', 'PrimaryDedicatedMonitoring', 'PrimaryMonitoring'."
  }

  validation {
    condition = length(flatten([for vm in values(var.virtual_machines_psn) :
      [for service in coalesce(split(", ", vm.services), []) :
        service if service != "Session" && service != "Profiler" && service != "TC-NAC" &&
        service != "SXP" && service != "DeviceAdmin" && service != "PassiveIdentity" &&
    service != "pxGrid" && service != "pxGridCloud"]])) == 0
    error_message = "Services can only accept values from Session, Profiler, TC-NAC, SXP, DeviceAdmin, PassiveIdentity, pxGrid, pxGridCloud."
  }

  validation {
    condition     = length([for vm in values(var.virtual_machines_psn) : vm if vm.roles == null && vm.services == null]) == 0
    error_message = "PSN node should contain one of the role or service"
  }

}