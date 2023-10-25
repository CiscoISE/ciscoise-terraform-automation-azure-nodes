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
ise_vm_size_sku                 = "Standard_B2ms"     # Set the VM size for PAN nodes (Supported VM size - Standard_D4s_v4, Standard_D8s_v4, Standard_F16s_v2, Standard_F32s_v2, Standard_D16s_v4, Standard_D32s_v4, Standard_D64s_v4)
ise_vm_size_sku_psn             = "Standard_D4s_v4"   # Set the VM size for PSN nodes (Supported VM size - Standard_D4s_v4, Standard_D8s_v4, Standard_F16s_v2, Standard_F32s_v2, Standard_D16s_v4, Standard_D32s_v4, Standard_D64s_v4)
ise_vm_vm_sa_caching            = "ReadWrite"         # OS disk cachine - (Do not change)
ise_vm_vm_storage_account_type  = "Premium_LRS"       # OS disk type - (Do not change)
admin_ssh_key_path              = "isekey.pub"        # Change the key name if you have your own key named other than "isekey.pub"
disk_size                       = 400                 # Set the VM disk size for PAN nodes (default is 300GB)
disk_size_psn                   = 600                 # Set the VM disk size for PSN nodes (default is 300GB)
ise_image_sku                   = "cisco-ise_3_2"     # Available options - cisco-ise_3_2 or cisco-ise_3_3
ise_image_version               = "3.2.543"           # Available options - 3.2.543 or 3.3.430
ise_offer                       = "cisco-ise-virtual" # Azure marketplace ISE image offer - (Do not change)
ise_plan_name                   = "cisco-ise_3_2"     # Available options - cisco-ise_3_2 or cisco-ise_3_3
ise_plan_product                = "cisco-ise-virtual" # Azure marketplace ISE image product - (Do not change)
ise_publisher                   = "cisco"             # Azure marketplace ISE image publisher - (Do not change)
marketplace_ise_image_agreement = true                # Accept Azure Marketplace term so that the image can be used to create VMs. Set the value to true/false based on output of (az vm image terms show --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_2)


# Enter the PAN and PSN Node hostnames:

# Enter the PAN node hostname in a list separated by comma, currently only Two PAN nodes are supported in this ISE stack deployment.

ise_pan_node_names = [
  "ise-pan-primary",
  "ise-pan-secondary"
]

# # Enter the PSN node hostname in a list separated by comma, currently only Eight PSN nodes are supported in this ISE stack deployment.

ise_psn_node_names = [
  "ise-psn-node-1",
  "ise-psn-node-2"
]

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