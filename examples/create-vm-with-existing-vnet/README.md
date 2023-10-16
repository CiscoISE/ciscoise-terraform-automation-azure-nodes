# Automated ISE setup with Infrastructure as Code using Terraform on Azure

This project runs terraform module to setup ISE infrastructure on Azure Cloud Platform.

## Requirements
- Terraform ~> 1.5.x
- Azure provider - Azurerm v3.69.0
- Azure CLI
- Azure subscription with at least `Contributor` level access and App Configuration Data Owner role assigned.
- Resource Group
- Virtual Network
- 3 Private Subnets - (2 subnets for deploying VM and Loadbalancer and, 1 - subnet delegated to service Microsoft.Web/serverFarms  for Function App VNET integration)

## Installations
1. To install terraform, follow the instructions as per your operating system - [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)

2. To install Azure CLI, follow the instructions mentioned here - [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Resources
- Resource Group
- 1-Virtual Network, 3-Public Subnets, 3-Private Subnets(2-VM+LB and, 1-Delegated Subnet for VNET integration with Function App), Private DNS zone, App Configuration.
- Function App, App Service Plan B1 - linux, Application Insights and Storage account
- Virtual Machines - 4 (2-Primary, Secondary nodes and 2-PSN nodes)
- Internal Load balancer

## Authenticating using the Azure CLI

To configure and allow access to Azure account, we need a user having atleast `Contributor` level access . Run the below command to get Azure access using CLI. It will prompt you to login through web browser

```
az login 
```

In case you are running this command on a server where you don't have any browser, run the below command and use the code to authenticate using any other machine.

```
az login --use-device-code
```
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code  to authenticate.

Please refer Terraform documentation for other available authentication methods.
Documentation - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

## Run terraform modules

Clone this git repo by using below this command 
  ```
git clone https://github3.cisco.com/techops-operation/ise_launch_template-terraform-azure-vm.git
  ```

Below is the cloned repository directory structure:
```
.
├── README.md
├── examples
│   ├── create-vm-with-existing-vnet
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── create-vm-with-new-vnet
│       ├── main.tf
│       ├── output.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── module
│   ├── loadbalancer_dns
│   │   ├── functionapp.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variable.tf
│   └── vm
│       ├── main.tf
│       ├── output.tf
│       ├── providers.tf
│       ├── user_data.tftpl
│       └── variables.tf
├── providers.tf
├── terraform.tfvars
└── variables.tf
```

Here, we are running it locally and will use Azure CLI for authentication and configure Terraform to use a specific `Subscription` by specifying it's value in `terraform.tfvars` file for variable named as `subscription` at path examples/create-vm-with-existing-vnet

To deploy using an existing VNET
```
cd examples/create-vm-with-existing-vnet
```

## Generating SSH-Key pair

For SSH access to ISE Virtual Machines, create a SSH keypair using below command under the directory   `examples/create-vm-with-existing-vnet` and update the variable `admin_ssh_key_path` value with  SSH public key name in `terraform.tfvars` file.

```
ssh-keygen -t rsa -m PEM -b 4096 -C "azureuser@myserver" -f isekey
```

Guide on how to create SSH keypair - https://learn.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed
## Update Terraform variables

- Check for the Azure ISE VM Image subscription Terms & Conditions status for specific version. Example:- Checking for ISE version cisco-ise_3_2 
  
```
az vm image terms show --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_2
```  

 If the output value is "accepted": false, then set the variable `marketplace_ise_image_agreement` to `false` in `terraform.tfvars` at path examples/create-vm-with-new-vnet 

 If the output value is "accepted": true, then set the variable  `marketplace_ise_image_agreement` to `true` . Default variable is set to `false`

#  Update the other variables as per the requirement.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_ssh_key_path"></a> [admin\_ssh\_key\_path](#input\_admin\_ssh\_key\_path) | Path to the SSH public key file | `string` | `"isekey.pub"` | yes |
| <a name="input_availability_zone_pan"></a> [availability\_zone\_pan](#input\_availability\_zone\_pan) | n/a | `string` | `"1"` | no |
| <a name="input_availability_zone_psn"></a> [availability\_zone\_psn](#input\_availability\_zone\_psn) | n/a | `string` | `"2"` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | ISE node disk size | `number` | `600` | no |
| <a name="input_dnsdomain"></a> [dnsdomain](#input\_dnsdomain) | Enter the FQDN of the DNS domain. The entry can contain ASCII characters, numerals, hyphens (-), and periods (.). | `string` | `"example.com"` | yes |
| <a name="input_ersapi"></a> [ersapi](#input\_ersapi) | Enter yes to enable ERS, or no to disallow ERS. | `string` | `"yes"` | no |
| <a name="input_frontend_ip_allocation"></a> [frontend\_ip\_allocation](#input\_frontend\_ip\_allocation) | Mention the Frontend Private IP address allocation type - Static or Dynamic | `string` | `"Dynamic"` | no |
| <a name="input_frontend_lb_ip_name"></a> [frontend\_lb\_ip\_name](#input\_frontend\_lb\_ip\_name) | Mention the Frontend IP address name | `string` | `"ise_lb_PrivateIPAddress"` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | Enter the Github URL of the repo hosting the Function App code | `string` | `""` | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | This token will be used to read the Github code having Repo and Workflow access | `string` | `""` | yes |
| <a name="input_ise_func_subnet"></a> [ise\_func\_subnet](#input\_ise\_func\_subnet) | Mention the subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms. | `string` | `"ise_func_subnet"` | yes |
| <a name="input_ise_image_sku"></a> [ise\_image\_sku](#input\_ise\_image\_sku) | ISE image sku - available values -  cisco-ise\_3\_2 & cisco-ise\_3\_3 | `string` | `"cisco-ise_3_2"` | no |
| <a name="input_ise_image_version"></a> [ise\_image\_version](#input\_ise\_image\_version) | ISE image version - available versions: 3.2.543 & 3.3.430 | `string` | `"3.2.543"` | no |
| <a name="input_ise_lb_backend_address_pool_name"></a> [ise\_lb\_backend\_address\_pool\_name](#input\_ise\_lb\_backend\_address\_pool\_name) | Mention the name for ISE Loadbalancer backend pool | `string` | `"ise-BackendAddressPool"` | no |
| <a name="input_ise_lb_name"></a> [ise\_lb\_name](#input\_ise\_lb\_name) | Provide the Loadbalancer name | `string` | `"ise-int-loadbalancer"` | no |
| <a name="input_ise_lb_sku"></a> [ise\_lb\_sku](#input\_ise\_lb\_sku) | Mention the Loadbalancer SKU | `string` | `"Standard"` | no |
| <a name="input_ise_lb_subnet_name"></a> [ise\_lb\_subnet\_name](#input\_ise\_lb\_subnet\_name) | Mention the subnet name for Loadbalancer | `string` | `"ps-prod-snet-app1"` | yes |
| <a name="input_ise_offer"></a> [ise\_offer](#input\_ise\_offer) | Image Offer | `string` | `"cisco-ise-virtual"` | no |
| <a name="input_ise_pan_node_names"></a> [ise\_pan\_node\_names](#input\_ise\_pan\_node\_names) | Mention the hostname for ISE PAN Primary and Secondary nodes | `list(string)` | <pre>[<br>  "ise-pan-primary",<br>  "ise-pan-secondary"<br>]</pre> | no |
| <a name="input_ise_plan_name"></a> [ise\_plan\_name](#input\_ise\_plan\_name) | Plan Name for using the Marketplace ISE image, available options - cisco-ise\_3\_2 & cisco-ise\_3\_3 | `string` | `"cisco-ise_3_2"` | no |
| <a name="input_ise_plan_product"></a> [ise\_plan\_product](#input\_ise\_plan\_product) | Value of Image Offer for using inside VM resource plan block | `string` | `"cisco-ise-virtual"` | no |
| <a name="input_ise_psn_node_names"></a> [ise\_psn\_node\_names](#input\_ise\_psn\_node\_names) | Mention the hostname for ISE PSN nodes | `list(string)` | <pre>[<br>  "ise-psn-node-1",<br>  "ise-psn-node-2"<br>]</pre> | no |
| <a name="input_ise_publisher"></a> [ise\_publisher](#input\_ise\_publisher) | Name of the Image publisher | `string` | `"cisco"` | no |
| <a name="input_ise_resource_group"></a> [ise\_resource\_group](#input\_ise\_resource\_group) | Mention the Resource Group name | `string` | `"ise-resource-group"` | yes |
| <a name="input_ise_vm_adminuser_name"></a> [ise\_vm\_adminuser\_name](#input\_ise\_vm\_adminuser\_name) | ISE admin username | `string` | `"iseadmin"` | no |
| <a name="input_ise_vm_size_sku"></a> [ise\_vm\_size\_sku](#input\_ise\_vm\_size\_sku) | Mention the Virtual Machine size as per the ISE recommendations - https://www.cisco.com/c/en/us/td/docs/security/ise/ISE_on_Cloud/b_ISEonCloud/m_ISEonAzureServices.html | `string` | `"Standard_B2ms"` | yes |
| <a name="input_ise_vm_size_sku_psn"></a> [ise\_vm\_size\_sku\_psn](#input\_ise\_vm\_size\_sku\_psn) | Mention the Virtual Machine size as per the ISE recommendations - https://www.cisco.com/c/en/us/td/docs/security/ise/ISE_on_Cloud/b_ISEonCloud/m_ISEonAzureServices.html | `string` | `"Standard_B2ms"` | yes |
| <a name="input_ise_vm_subnet_name"></a> [ise\_vm\_subnet\_name](#input\_ise\_vm\_subnet\_name) | Mention the subnet name for Virtual Machine/ ISE nodes | `string` | `"ps-prod-snet-app2"` | no |
| <a name="input_ise_vm_vm_sa_caching"></a> [ise\_vm\_vm\_sa\_caching](#input\_ise\_vm\_vm\_sa\_caching) | n/a | `string` | `"ReadWrite"` | no |
| <a name="input_ise_vm_vm_storage_account_type"></a> [ise\_vm\_vm\_storage\_account\_type](#input\_ise\_vm\_vm\_storage\_account\_type) | Disk storage type | `string` | `"Premium_LRS"` | no |
| <a name="input_ise_vnet_dns_link_name"></a> [ise\_vnet\_dns\_link\_name](#input\_ise\_vnet\_dns\_link\_name) | Provide the name for VNET link to associate with the Provide DNS zone | `string` | `"ise_vnet_dns_link"` | no |
| <a name="input_location"></a> [location](#input\_location) | Mention the region where you want to deploy resources | `string` | `"East US"` | no |
| <a name="input_marketplace_ise_image_agreement"></a> [marketplace\_ise\_image\_agreement](#input\_marketplace\_ise\_image\_agreement) | If ISE marketplace image agreement is already done set the value to 'true' else set it as 'false'. You can check the status by executing the Azure CLI command - 'az vm image terms show --publisher cisco  --offer cisco-ise-virtual --plan cisco-ise\_3\_2' | `bool` | `false` | no |
| <a name="input_marketplace_ise_image_agreement_psn"></a> [marketplace\_ise\_image\_agreement\_psn](#input\_marketplace\_ise\_image\_agreement\_psn) | If ISE marketplace image agreement is already done set the value to 'true' else set it as 'false'. You can check the status by executing the Azure CLI command - 'az vm image terms show --publisher cisco  --offer cisco-ise-virtual --plan cisco-ise\_3\_2' | `bool` | `true` | no |
| <a name="input_ntpserver"></a> [ntpserver](#input\_ntpserver) | Enter the IPv4 address or FQDN of the NTP server that must be used for synchronization, for example, time.nist.gov. | `string` | `"time.google.com"` | yes |
| <a name="input_openapi"></a> [openapi](#input\_openapi) | Enter yes to enable OpenAPI, or no to disallow OpenAPI. | `string` | `"yes"` | no |
| <a name="input_password"></a> [password](#input\_password) | Configure a password for GUI-based login to Cisco ISE. The password that you enter must comply with the Cisco ISE password policy. The password must contain 6 to 25 characters and include at least one numeral, one uppercase letter, and one lowercase letter. The password cannot be the same as the username or its reverse (iseadmin or nimdaesi), cisco, or ocsic. The allowed special characters are @~*!,+=\_-. | `string` | `"C!sc0Ind1@"` | no |
| <a name="input_primarynameserver"></a> [primarynameserver](#input\_primarynameserver) | Enter the IP address of the primary name server. Only IPv4 addresses are supported | `string` | `"168.63.129.16"` | yes |
| <a name="input_pxGrid"></a> [pxGrid](#input\_pxGrid) | Enter yes to enable pxGrid, or no to disallow pxGrid | `string` | `"yes"` | no |
| <a name="input_pxgrid_cloud"></a> [pxgrid\_cloud](#input\_pxgrid\_cloud) | Enter yes to enable pxGrid Cloud or no to disallow pxGrid Cloud. To enable pxGrid Cloud, you must enable pxGrid. If you disallow pxGrid, but enable pxGrid Cloud, pxGrid Cloud services are not enabled on launch. | `string` | `"yes"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | Add the Azure subscription ID | `string` | `"4af28428-fadd-42d1-ba1c-ba3eef6d4a6c"` | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Enter a timezone, for example, Etc/UTC. We recommend that you set all the Cisco ISE nodes to the Coordinated Universal Time (UTC) timezone | `string` | `"UTC"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Mention the Virtual Network (VNET) name | `string` | `"ps-prod-vnet"` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer_frontendIP"></a> [loadbalancer\_frontendIP](#output\_loadbalancer\_frontendIP) | Loadbalancer Private IP Address |
| <a name="output_pan_node_name"></a> [pan\_node\_name](#output\_pan\_node\_name) | PAN node hostname |
| <a name="output_pan_private_ip_address"></a> [pan\_private\_ip\_address](#output\_pan\_private\_ip\_address) | PAN node Private IP Address |
| <a name="output_private_dns_records"></a> [private\_dns\_records](#output\_private\_dns\_records) | ISE node FQDN  |
| <a name="output_psn_node_name"></a> [psn\_node\_name](#output\_psn\_node\_name) | PSN node hostnames |
| <a name="output_psn_private_ip_address"></a> [psn\_private\_ip\_address](#output\_psn\_private\_ip\_address) | PAN node Private IP Address  |
## Initialize , Review and Apply

Run below commands
 ```
 terraform init --upgrade
 terraform plan
 terraform apply
 ```

Type 'yes' when prompted after running terraform apply

After setting up ISE infra using terraform, it will take 45-60 minutes for the stack to deploy and ISE application to come up.
