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
  default = "10.0.0.0/16"
}

variable "ise_lb_subnet_name" {
  type    = string
  default = ""
}

variable "ise_vm_subnet_name" {
  type    = string
  default = ""
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = ""
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
# variable "public_subnet_nsg_associations" {
#   type = list(object({
#     public_subnets  = string
#     cisco_ise_nsg     = string
#   }))
#   default = []
# }

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
