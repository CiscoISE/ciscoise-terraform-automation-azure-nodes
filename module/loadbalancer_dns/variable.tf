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
  description = "Enter the Virtual Network (VNET) name."
  type        = string
  default     = ""
}

variable "ise_lb_subnet_name" {
  description = "Enter the subnet name for Loadbalancer."
  type        = string
  default     = ""
}

variable "ise_vm_subnet_name" {
  description = "Enter the subnet name for Virtual Machine/ ISE nodes."
  type        = string
  default     = ""
}

variable "ise_func_subnet" {
  description = "Mention the subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms."
  type        = string
  default     = ""
}


######################################################################################
############## Block for ISE Internal Loadbalancer related variables  ################
######################################################################################

variable "ise_lb_name" {
  description = "Enter the Loadbalancer name"
  type        = string
  default     = ""
}

variable "ise_lb_sku" {
  description = "Enter the Loadbalancer SKU type"
  type        = string
  default     = ""
}

variable "frontend_lb_ip_name" {
  description = "Enter the Frontend IP address name"
  type        = string
  default     = ""
}

variable "frontend_ip_allocation" {
  description = "Enter the Frontend Private IP address allocation type - Static or Dynamic"
  type        = string
  default     = ""
}

variable "ise_lb_backend_address_pool_name" {
  description = "Enter the name for ISE Loadbalancer backend pool"
  type        = string
  default     = ""
}


######################################################################################
##################    Block for Private DNS zone related variables   #################
######################################################################################

variable "ise_vm_private_dns_zone_name" {
  description = "Enter the name for Private DNS zone"
  type        = string
  default     = ""
}

variable "ise_vnet_dns_link_name" {
  description = "Enter the name for link between VNET and Private DNS zone"
  type        = string
  default     = ""
}


######################################################################################
##############    Block for ISE App Configuration related variables   ################
######################################################################################

# variable "ise_node_names" {
#   description = "Enter the desired number of ISE Virtual Machine hostname in a list separated by comma"
#   type        = list(string)
#   default     = []
# }

variable "appConIP" {
  description = "App Configuration Key variables for storing PAN primary and secondary IP address"
  type        = list(string)
  default     = ["primary_ip", "secondary_ip"]
}

# variable "ise_pan_node_names" {
#   description = "Enter the PAN primary and secondary ISE Virtual Machine hostname in a list separated by comma"
#   type        = list(string)
#   default     = []
# }

# variable "ise_psn_node_names" {
#   description = "Enter the PSN ISE Virtual Machine hostname in a list separated by comma"
#   type        = list(string)
# }


variable "appConfqdn" {
  description = "App Configuration Key variables for storing PAN primary and secondary IP node Fully Qualified Domain Name(FQDN)"
  type        = list(string)
  default     = ["primary_fqdn", "secondary_fqdn"]
}

variable "username_password_key" {
  description = "App Configuration Key variable for storing ISE nodes Username and Password."
  type        = list(string)
  default     = ["admin_username", "admin_password"]
}

variable "ise_vm_adminuser_name" {
  description = "App Configuration variables for storing ISE nodes Username."
  type        = string
  default     = ""
}

variable "password" {
  description = "App Configuration variables for storing ISE nodes Password."
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

variable "virtual_machines_pan" {
  type = map(object({
    size       = string
    storage    = number
    services   = optional(string)
    roles      = optional(string)
    enable_nlb = optional(bool, false)
  }))
}

variable "virtual_machines_psn" {
  type = map(object({
    size       = string
    storage    = number
    services   = optional(string, "Session, Profiler")
    roles      = optional(string)
    enable_nlb = optional(bool, false)
  }))
}