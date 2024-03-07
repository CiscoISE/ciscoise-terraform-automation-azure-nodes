# Azure Setup related variables:

subscription       = "4af28428-fadd-42d1-ba1c-ba3eef6d4a6c" # Enter your Azure Subscription ID.
ise_resource_group = "Cisco_ISE_RG_NEW"                     # Enter the Azure Resource Group name to be created for ISE setup.
location           = "East US"                              # Enter the region/location to deploy the ISE setup that supports Availability Zone - Check here for Availability Zone support: https://azure.microsoft.com/en-gb/explore/global-infrastructure/geographies/#geographies


# Azure Networking related variables:

vnet_name    = "ise_vnet"    # Enter the Virtual Network(VNET) name to be created.
vnet_address = "10.0.0.0/16" # Enter the Virtual Network(VNET) CIDR.

# Enter the Subnet CIDR for Private Subnets to be created for ISE setup in a list separated by comma.
private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24",
  "10.0.13.0/24"
]
# Enter the Subnet CIDR for Public Subnets to be created for ISE setup in a list separated by comma.                                                        
public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]


# Subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms 
ise_func_subnet = "ise_func_subnet"

# Enter the CIDR for Function App VNET integration subnet to be created, try to keep the IP address range smaller as it cannot be used to deploy other resources except Azure Function VNET integration.
ise_func_subnet_cidr = [
  "10.0.14.0/26"
]

# Azure ISE VM related variables:

ise_vm_adminuser_name = "iseadmin" # Enter the ISE admin username / same is for SSH
# ise_vm_size_sku                 = "Standard_B2ms"     # Set the VM size for PAN nodes (Supported VM size - Standard_D4s_v4, Standard_D8s_v4, Standard_F16s_v2, Standard_F32s_v2, Standard_D16s_v4, Standard_D32s_v4, Standard_D64s_v4)
# ise_vm_size_sku_psn             = "Standard_D4s_v4"   # Set the VM size for PSN nodes (Supported VM size - Standard_D4s_v4, Standard_D8s_v4, Standard_F16s_v2, Standard_F32s_v2, Standard_D16s_v4, Standard_D32s_v4, Standard_D64s_v4)
ise_vm_vm_sa_caching           = "ReadWrite"   # OS disk cachine - (Do not change)
ise_vm_vm_storage_account_type = "Premium_LRS" # OS disk type - (Do not change)
admin_ssh_key_path             = "isekey.pub"  # Change the key name if you have your own key named other than "isekey.pub"
# disk_size                       = 400                 # Set the VM disk size for PAN nodes (default is 300GB)
# disk_size_psn                   = 600                 # Set the VM disk size for PSN nodes (default is 300GB)
ise_image_sku                   = "cisco-ise_3_2"     # Available options - cisco-ise_3_2 or cisco-ise_3_3
ise_image_version               = "3.2.543"           # Available options - 3.2.543 or 3.3.430
ise_offer                       = "cisco-ise-virtual" # Azure marketplace ISE image offer - (Do not change)
ise_plan_name                   = "cisco-ise_3_2"     # Available options - cisco-ise_3_2 or cisco-ise_3_3
ise_plan_product                = "cisco-ise-virtual" # Azure marketplace ISE image product - (Do not change)
ise_publisher                   = "cisco"             # Azure marketplace ISE image publisher - (Do not change)
marketplace_ise_image_agreement = true                # Set the value to true/false based on output of command (az vm image terms show --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_2)  - Azure Marketplace TnC required to accept so that the image can be used to create VMs. 


# ISE configuration related variables

primarynameserver = "168.63.129.16"   # Enter the IP address of the primary name server. Only IPv4 addresses are supported.
dnsdomain         = "example.com"     # Enter the FQDN of the DNS domain. The entry can contain ASCII characters, numerals, hyphens (-), and periods (.).
ntpserver         = "time.google.com" # Enter the IPv4 address or FQDN of the NTP server that must be used for synchronization, for example, time.nist.gov.
timezone          = "UTC"             # Enter a timezone, for example, Etc/UTC. We recommend that you set all the Cisco ISE nodes to the Coordinated Universal Time (UTC) timezone.
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

github_repo  = "https://github.com/ro6it/ise-auto-setup"
github_token = "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"


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
    5. Valid characters for hostnames are ASCII(7) letters from a to z , the digits from 0 to 9 , and the hyphen (−).

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
    size : "Standard_B2ms"
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
  ise-psn-node-1 : {
    services : "Session, Profiler, SXP, DeviceAdmin"
    size : "Standard_D4s_v4"
    storage : 500
  }

  ise-psn-node-2 : {
    roles : "PrimaryDedicatedMonitoring"
    services : "PassiveIdentity, pxGrid, pxGridCloud"
    size : "Standard_D4s_v4"
    storage : 550
  }

  ise-psn-node-3 : {
    size : "Standard_D4s_v4"
    services : "PassiveIdentity, pxGrid"
    storage : 600
  }

  ise-psn-node-test : {
    size : "Standard_D4s_v4"
    services : "Session, Profiler"
    storage : 600
  }
}

# virtual_machines_psn = {
#   # ise-psn-node-1 : {
#   #   services : "Session, Profiler, SXP, DeviceAdmin"
#   #   size : "Standard_D4s_v4"
#   #   storage : 500
#   }
