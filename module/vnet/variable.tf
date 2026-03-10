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

variable "subscription" {
  type    = string
  default = ""
}

variable "ise_resource_group" {
  type    = string
  default = ""
}

variable "vnet_name" {
  type    = string
  default = ""
}

variable "vnet_address" {
  type    = string
  default = ""
}

variable "ise_lb_subnet_name" {
  type    = string
  default = ""
}

variable "ise_vm_subnet_name" {
  type    = string
  default = ""
}

variable "ise_func_subnet" {
  description = "Mention the subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms."
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region for resource deployment"
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

variable "public_subnet_nsg_associations" {
  type = list(object({
    subnet_index = number
    nsg_index    = number
  }))
  default = [
    {
      subnet_index = 0
      nsg_index    = 0
    },
    {
      subnet_index = 1
      nsg_index    = 1
    },
    {
      subnet_index = 2
      nsg_index    = 2
    }
  ]
}

variable "private_subnet_nsg_associations" {
  type = list(object({
    subnet_index = number
    nsg_index    = number
  }))
  default = [
    {
      subnet_index = 0
      nsg_index    = 0
    },
    {
      subnet_index = 1
      nsg_index    = 1
    },
    {
      subnet_index = 2
      nsg_index    = 2
    }
  ]
}