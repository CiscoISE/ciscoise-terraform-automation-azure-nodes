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

# Azure Setup related variables:

subscription       = "4af28428-fadd-42d1-ba1c-ba3eef6d4a6c" # Enter your Azure Subscription ID
ise_resource_group = "ise-tf-test-rg"                       # Enter your existing Azure Resource Group name in which you want to deploy ISE stack and resource group must be created in the location that supports Availability zone.
location           = "Central India"                        # Enter the region/location that supports Availability Zone - Check here: https://azure.microsoft.com/en-gb/explore/global-infrastructure/geographies/#geographies


# Azure Networking related variables:

vnet_name          = "isetestvnet"       # Enter your existing Virtual Network(VNET) name.
ise_vm_subnet_name = "ps-prod-snet-app2" # Enter the existing Subnet name for ISE Virtual Machine deployment. 
ise_func_subnet    = "ise_func_subnet"   # Enter the existing Subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms (If do not exist, please create a new one).
ise_lb_subnet_name = "ps-prod-snet-app1" # Enter the existing Subnet name for Internal Loadbalancer deployment 


# Azure ISE VM related variables:

ise_vm_adminuser_name           = "iseadmin"          # Enter the ISE admin username / same is for SSH
ise_vm_vm_sa_caching            = "ReadWrite"         # OS disk cachine - (Do not change)
ise_vm_vm_storage_account_type  = "Premium_LRS"       # OS disk type - (Do not change)
admin_ssh_key_path              = "isekey.pub"        # Change the key name if you have your own key named other than "isekey.pub"
ise_image_sku                   = "cisco-ise_3_2"     # Available options - cisco-ise_3_2, cisco-ise_3_3 or  cisco-ise_3_4
ise_image_version               = "3.2.543"           # Available options - 3.2.543, 3.3.430 or 3.4.608
ise_offer                       = "cisco-ise-virtual" # Azure marketplace ISE image offer - (Do not change)
ise_plan_name                   = "cisco-ise_3_2"     # Available options - cisco-ise_3_2, cisco-ise_3_3 or cisco-ise_3_4
ise_plan_product                = "cisco-ise-virtual" # Azure marketplace ISE image product - (Do not change)
ise_publisher                   = "cisco"             # Azure marketplace ISE image publisher - (Do not change)
marketplace_ise_image_agreement = true                # Set the value to true/false based on output of command (az vm image terms show --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_2)  - Azure Marketplace TnC required to accept so that the image can be used to create VMs. 


# ISE configuration related variables

primarynameserver = "168.63.129.16"   # Enter the IP address of the primary name server. Only IPv4 addresses are supported.
dnsdomain         = "example.com"     # Enter the FQDN of the DNS domain. The entry can contain ASCII characters, numerals, hyphens (-), and periods (.).
ntpserver         = "time.google.com" # Enter the IPv4 address or FQDN of the NTP server that must be used for synchronization, for example, time.nist.gov.

# Optional secondary and tertiary DNS/NTP servers (only used for ISE 3.4+)
# Uncomment and set values if you want to use secondary/tertiary servers
# secondarynameserver = "172.31.31.255"   # Enter the IP address of the secondary name server 
# tertiarynameserver  = "172.31.31.256"   # Enter the IP address of the tertiary name server 
# secondaryntpserver  = "time.cloudflare.com" # Enter the IPv4 address or FQDN of the secondary NTP server
# tertiaryntpserver   = "pool.ntp.org"    # Enter the IPv4 address or FQDN of the tertiary NTP server

timezone          = "UTC"             # Enter a timezone that is allowed by ISE nodes. For information on the supported timezone formats, refer to this documentation - https://www.cisco.com/c/en/us/td/docs/security/ise/3-3/cli_guide/b_ise_CLI_Reference_Guide_33/b_ise_CLIReferenceGuide_33_chapter_011.html?#wp2884933107
password          = "C!sc0Ind1@"      # Set a password for GUI-based login to Cisco ISE. The password that you enter must comply with the Cisco ISE password policy. The password must contain 6 to 25 characters and include at least one numeral, one uppercase letter, and one lowercase letter. The password cannot be the same as the username or its reverse (iseadmin or nimdaesi), cisco, or ocsic. The allowed special characters are @~*!,+=_-.
ersapi            = "yes"             # Enter yes to enable ERS, or no to disallow ERS.
openapi           = "yes"             # Enter yes to enable OpenAPI, or no to disallow OpenAPI.
pxGrid            = "yes"             # Enter yes to enable pxGrid, or no to disallow pxGrid.
pxgrid_cloud      = "yes"             # Enter yes to enable pxGrid Cloud or no to disallow pxGrid Cloud. To enable pxGrid Cloud, you must enable pxGrid. If you disallow pxGrid, but enable pxGrid Cloud, pxGrid Cloud services are not enabled on launch.


# Loadbalancer and Function App related variable

frontend_ip_allocation           = "Dynamic"                 # Enter the Frontend Private IP address allocation type - Static or Dynamic. - (Do not change)
frontend_lb_ip_name              = "ise_lb_PrivateIPAddress" # Enter the Frontend IP address name.
ise_lb_backend_address_pool_name = "ise-BackendAddressPool"  # Enter the name for ISE Loadbalancer backend pool.
ise_lb_name                      = "ise-int-loadbalancer"    # Enter the Loadbalancer name.
ise_lb_sku                       = "Standard"                # Enter the Loadbalancer SKU. - (Do not change)

ise_vnet_dns_link_name = "ise_vnet_dns_link" # Enter the name for VNET link to associate with the Private DNS zone.

github_repo = "https://github.com/CiscoISE/ciscoise-terraform-automation-azure-functions"
# github_token = "ghp_xxxxxxxxxxxxxxxxxxxxxxxxx"            # Enter Github token if azure function repo is private.


###############################################################
################# Block to Update ISE VM Details ##############
###############################################################
/*

Valid VM instance types are Standard_D4s_v4, Standard_D8s_v4, Standard_F16s_v2, Standard_F32s_v2, Standard_D16s_v4, Standard_D32s_v4, Standard_D64s_v4 (Size vary from device to device)
Allowed Storage size - (Minimum 300GB and Maximum 32TiB/region/subscription)
Allowed roles are : PrimaryAdmin, SecondaryAdmin, PrimaryMonitoring, SecondaryMonitoring, PrimaryDedicatedMonitoring, SecondaryDedicatedMonitoring, Standalone
Allowed services are : Session, Profiler, TC-NAC, SXP, DeviceAdmin, PassiveIdentity, pxGrid, pxGridCloud

NOTE: For configuration, please make sure to follow the syntax as mentioned and follow below points before updating the variables
    1. Do not pass any services or roles values for primary pan node in virtual_machines_pan variable.
    2. Secondary pan node supports SecondaryAdmin, SecondaryMonitoring and PrimaryMonitoring roles.
    3. PSN node can act as a Mnt (Monitoring) node by assigning any one of these roles - SecondaryMonitoring, SecondaryDedicatedMonitoring, PrimaryMonitoring or PrimaryDedicatedMonitoring
    4. Monitoring role can only be passed once across both the virtual_machines_pan and virtual_machines_psn variable
    5. Service pxGridCloud cannot be added more than once in workload nodes.
    6. Valid characters for hostnames are ASCII(7) letters from a to z , the digits from 0 to 9 , and the hyphen (−).
    7. To create only Primary and secondary nodes without any PSN's, virtual_machines_psn variable should be set to {}
*/

# Enter the PAN node hostname as key and other allowed attributes in the values - (Allowed attribues size, storage, services, roles) separated by comma, currently only Two PAN nodes are supported in this ISE stack deployment.
# NOTE: Hostname only supports alphanumeric characters and hyphen (-). The length of the hostname should not exceed 19 characters, otherwise deployment will fail

/*
This is the reference block for ISE node variables -  How to update the variable and it's attributes
  {
    <hostname> = {
      size = "<vm_size>"
      storage = "<storage_size>"
      services =  "<service_1>,<service_2>"
      roles = "<role_1>,<role_2>"
    }
  }


Example usage -

virtual_machines_pan = {
  ise-pan-secondary: {
    roles: "SecondaryAdmin, SecondaryMonitoring"
    services: "Session, Profiler, pxGrid"
    size: "Standard_B2ms"
    storage: 500
  }
}

*/

virtual_machines_pan = {
  ise-pan-primary : {
    size : "Standard_D8s_v3"
    storage : 400
  }

  ise-pan-secondary : {
    roles : "SecondaryAdmin"
    services : "Session, Profiler, pxGrid"
    size : "Standard_B2ms"
    storage : 500
  }
}


# Enter the PSN node hostname as key and other allowed attributes in the values - (Allowed attribues size, storage, services, roles) comma space separated, currently only Eight PSN nodes are supported in this ISE stack deployment.
# NOTE: Hostname only supports alphanumeric characters and hyphen (-). The length of the hostname should not exceed 19 characters, otherwise deployment will fail

/*
This is the reference block for ISE node variables -  How to update the variable and it's attributes
  {
    <hostname> = {
      size = "<vm_size>"
      storage = "<storage_size>"
      services =  "<service_1>,<service_2>"
      roles = "<role_1>,<role_2>"
    }
  }


Example usage -

virtual_machines_psn = {
  ise-psn-node-2: {
    roles: "PrimaryDedicatedMonitoring"
    services: "Session, Profiler, pxGrid"
    size: "Standard_B2ms"
    storage: 500
  }
}

*/

virtual_machines_psn = {
  ise-psn-node-01 : {
    services : "Session, Profiler, SXP, DeviceAdmin"
    size : "Standard_D4s_v4"
    storage : 500
  }

  ise-psn-node-02 : {
    roles : "PrimaryDedicatedMonitoring"
    services : "PassiveIdentity, pxGrid, pxGridCloud"
    size : "Standard_D4s_v4"
    storage : 550
  }

  ise-psn-node-03 : {
    size : "Standard_D4s_v4"
    services : "PassiveIdentity, pxGrid"
    storage : 600
  }

  ise-psn-node-test : {
    services : "Session, Profiler"
    size : "Standard_D4s_v4"
    storage : 500
  }
}
