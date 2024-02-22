######################################################################################
#######################     Block to add Azure variables   ###########################
######################################################################################

variable "subscription" {
  description = "Add the Azure subscription ID"
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
#######################  Block for VNET related variables  ###########################
######################################################################################

variable "vnet_name" {
  description = "Mention the Virtual Network (VNET) name"
  type        = string
  default     = ""
}

variable "ise_lb_subnet_name" {
  description = "Mention the subnet name for Loadbalancer"
  type        = string
  default     = ""
}

variable "ise_vm_subnet_name" {
  description = "Mention the subnet name for Virtual Machine/ ISE nodes"
  type        = string
  default     = ""
}

variable "ise_func_subnet" {
  description = "Mention the subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms."
  type        = string
  default     = ""
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
  description = "Plan Name for using the Marketplace ISE image, available options - cisco-ise_3_2 & cisco-ise_3_3"
  type        = string
  default     = ""
}

variable "ise_plan_product" {
  description = "Value of Image Offer for using inside VM resource plan block"
  type        = string
  default     = ""
}

variable "ise_image_sku" {
  description = "ISE image sku - available values -  cisco-ise_3_2 & cisco-ise_3_3 "
  type        = string
  default     = ""
}

variable "ise_image_version" {
  description = "ISE image version - available versions: 3.2.543 & 3.3.430 "
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
  # default = {
  #   ise-pan-primary   = { size = "Standard_B2ms", storage = 400 } # NOTE: Don't pass the values for services and roles in Primary Node.
  #   ise-pan-secondary = { size = "Standard_B2ms", storage = 500, services = "Session, Profiler, pxGrid", roles = "SecondaryAdmin" }
  # }

  validation {
    #condition     = length([for vm in values(var.virtual_machines_pan) : vm.roles if vm.roles != null && (vm.roles != "SecondaryMonitoring" && vm.roles != "SecondaryAdmin" && vm.roles != "PrimaryMonitoring")]) == 0
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
  # default = {
  #   ise-psn-node-1 = { size = "Standard_D4s_v4", storage = 500, services = "Session, Profiler, SXP, DeviceAdmin" }
  #   ise-psn-node-2 = { size = "Standard_D4s_v4", storage = 550, services = "PassiveIdentity, pxGrid, pxGridCloud", roles = "PrimaryDedicatedMonitoring" }
  #   # ise-psn-node-3 = { size = "Standard_D4s_v4", storage = 600, services = "Session, Profiler"}
  #   ise-psn-node-3    = { size = "Standard_D4s_v4", storage = 600 }
  #   ise-psn-node-test = { size = "Standard_D4s_v4", storage = 600 }

  # }

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