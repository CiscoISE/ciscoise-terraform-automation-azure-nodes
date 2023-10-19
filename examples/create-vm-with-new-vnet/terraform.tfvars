# Azure Setup related variables:

subscription       = "4af28428-fadd-42d1-ba1c-ba3eef6d4a6c"       # Enter the Azure Subscription ID
ise_resource_group = "Cisco_ISE_RG"                               # Enter the Azure Resource Group name
location           = "East US"                                    # Enter the region/location that supports Availability Zone - Check here: https://azure.microsoft.com/en-gb/explore/global-infrastructure/geographies/#geographies


# Azure Networking related variables:

vnet_name    = "ise_vnet"                                         # Enter the Virtual Network name
vnet_address = "10.0.0.0/16"                                      # Enter the Virtual Network CIDR
                                                                  # Enter the Subnet CIDR for Private Subnets
private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24",
  "10.0.13.0/24"
]        
                                                                  # Enter the Subnet CIDR for Public Subnets                                                        
public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

ise_func_subnet = "ise_func_subnet"                               # Subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms 
ise_func_subnet_cidr = [
  "10.0.14.0/26"
]

# Azure ISE VM related variables:

ise_vm_adminuser_name               = "iseadmin"                 # Enter the ISE admin username / same is for SSH
ise_vm_size_sku                     = "Standard_B2ms"            # Set the VM size for PAN nodes (Supported VM size - Standard_D4s_v4, Standard_D8s_v4, Standard_F16s_v2, Standard_F32s_v2, Standard_D16s_v4, Standard_D32s_v4, Standard_D64s_v4)
ise_vm_size_sku_psn                 = "Standard_B2ms"            # Set the VM size for PSN nodes (Supported VM size - Standard_D4s_v4, Standard_D8s_v4, Standard_F16s_v2, Standard_F32s_v2, Standard_D16s_v4, Standard_D32s_v4, Standard_D64s_v4)
ise_vm_vm_sa_caching                = "ReadWrite"
ise_vm_vm_storage_account_type      = "Premium_LRS"
admin_ssh_key_path                  = "isekey.pub"               # Change the key name if you have your own key named other than "isekey.pub"
disk_size                           = 600                        # Set the VM disk size (default is 300GB)
ise_image_sku                       = "cisco-ise_3_2"            # Available options - cisco-ise_3_2 or cisco-ise_3_3
ise_image_version                   = "3.2.543"                  # Available options - 3.2.543 or 3.3.430
ise_offer                           = "cisco-ise-virtual"
ise_plan_name                       = "cisco-ise_3_2"            # Available options - cisco-ise_3_2 or cisco-ise_3_3
ise_plan_product                    = "cisco-ise-virtual"
ise_publisher                       = "cisco"
marketplace_ise_image_agreement     = true                       # Set the value to true/false based on output of (az vm image terms show --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_2)
marketplace_ise_image_agreement_psn = true

# Enter the PAN and PSN Node hostnames:

ise_pan_node_names = [
  "ise-pan-primary",
  "ise-pan-secondary"
]

ise_psn_node_names = [
  "ise-psn-node-1",
  "ise-psn-node-2",
  "ise-psn-node-3"
]


# ISE configuration related variables

primarynameserver = "168.63.129.16"                              # Enter the IP address of the primary name server. Only IPv4 addresses are supported.
dnsdomain         = "example.com"                                # Enter the FQDN of the DNS domain. The entry can contain ASCII characters, numerals, hyphens (-), and periods (.).
ntpserver         = "time.google.com"                            # Enter the IPv4 address or FQDN of the NTP server that must be used for synchronization, for example, time.nist.gov.
timezone          = "UTC"                                        # Enter a timezone, for example, Etc/UTC. We recommend that you set all the Cisco ISE nodes to the Coordinated Universal Time (UTC) timezone.
password          = "C!sc0Ind1@"                                 # Set a password for GUI-based login to Cisco ISE. The password that you enter must comply with the Cisco ISE password policy. The password must contain 6 to 25 characters and include at least one numeral, one uppercase letter, and one lowercase letter. The password cannot be the same as the username or its reverse (iseadmin or nimdaesi), cisco, or ocsic. The allowed special characters are @~*!,+=_-.
ersapi            = "yes"                                        # Enter yes to enable ERS, or no to disallow ERS.
openapi           = "yes"                                        # Enter yes to enable OpenAPI, or no to disallow OpenAPI.
pxGrid            = "yes"                                        # Enter yes to enable pxGrid, or no to disallow pxGrid.
pxgrid_cloud      = "yes"                                        # Enter yes to enable pxGrid Cloud or no to disallow pxGrid Cloud. To enable pxGrid Cloud, you must enable pxGrid. If you disallow pxGrid, but enable pxGrid Cloud, pxGrid Cloud services are not enabled on launch.


# Loadbalancer and Function App related variable

frontend_ip_allocation           = "Dynamic"                     # Enter the Frontend Private IP address allocation type - Static or Dynamic.
frontend_lb_ip_name              = "ise_lb_PrivateIPAddress"     # Enter the Frontend IP address name.
ise_lb_backend_address_pool_name = "ise-BackendAddressPool"      # Enter the name for ISE Loadbalancer backend pool.
ise_lb_name                      = "ise-int-loadbalancer"        # Enter the Loadbalancer name.
ise_lb_sku                       = "Standard"                    # Enter the Loadbalancer SKU.

ise_vnet_dns_link_name = "ise_vnet_dns_link"                     # Enter the name for VNET link to associate with the Private DNS zone.

github_repo  = "https://github.com/ro6it/ise-auto-setup"
github_token = "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"


