## Terraform variables

The module uses below inputs.

:warning: **Please only update the terraform input variables in `terraform.tfvars` file**


### Generating SSH-Key pair

For SSH access to ISE Virtual Machines, create a SSH keypair using below command and update the variable `admin_ssh_key_path` value with  SSH public key name in `terraform.tfvars` file.

`NOTE:` Please make sure you are generating SSH key-pair at path `examples/create-vm-with-existing-vnet`

```
ssh-keygen -t rsa -m PEM -b 4096 -C "azureuser@myserver" -f isekey
```

Guide on how to create SSH keypair - https://learn.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed



### Update ISE image subscription agreement variable

- Check for the Azure ISE VM Image subscription Terms & Conditions status for specific version. Need to accept Azure Marketplace term so that the image can be used to create VMs. Example:- Checking for ISE version cisco-ise_3_2. Run the below command to check for ISE image subscription in Azure marketplace

```
az vm image terms show --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_2
```  
  
:memo: `NOTE:`
 - If the output value is "accepted": false, then set the variable `marketplace_ise_image_agreement` to `false` in `terraform.tfvars` .
    - This means the image TnC are are not accepted. We need to set the variable as 'false' to ensure it is accepted by the module.
 - If the output value is "accepted": true, then set the variable  `marketplace_ise_image_agreement` to `true` in `terraform.tfvars` . 
    - This means the image TnC are are accepted. We need to set the variable as 'true' and we are good to go.
```
az vm image terms show --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_2
```  

After updating the `terraform.tfvars` file, run the below commands to apply the changes and bring Up the ISE stack:

```
terraform init --upgrade
terraform plan
terraform apply
```

Type 'yes' when prompted after running terraform apply

After setting up ISE infra using terraform, it will take 45-60 minutes for the stack to deploy and ISE application to come up.

## Required VNET resources

Please review the table below and ensure to create the specified VNET resources for setting up the VNET infrastructure

| Resource Type | Count | Comments |
| ---- |:----:| ---- |
| Resource Group | 1 |  |
| Virtual Network (VNET) | 1 | Private network |
| NAT Gateway | 1 | For outbound requests from private subnets |
| Public IP addresss | 1 | For NAT Gateway |
| Network Security Group(NSG) | 2 | Separate NSG for public and Private subnets |
| Subnets | 3 Private, 3 Public, 1 delegated for Function App | All resources are being deployed in private subnets  |


## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_admin_ssh_key_path"></a> [admin\_ssh\_key\_path](#input\_admin\_ssh\_key\_path) | Path to the SSH public key file | `string` | `"isekey.pub"` |
| <a name="input_dnsdomain"></a> [dnsdomain](#input\_dnsdomain) | Enter the FQDN of the DNS domain. The entry can contain ASCII characters, numerals, hyphens (-), and periods (.). | `string` | `"example.com"` |
| <a name="input_ersapi"></a> [ersapi](#input\_ersapi) | Enter yes to enable ERS, or no to disallow ERS. | `string` | `"yes"` |
| <a name="input_frontend_ip_allocation"></a> [frontend\_ip\_allocation](#input\_frontend\_ip\_allocation) | Mention the Frontend Private IP address allocation type - Static or Dynamic | `string` | `"Dynamic"` |
| <a name="input_frontend_lb_ip_name"></a> [frontend\_lb\_ip\_name](#input\_frontend\_lb\_ip\_name) | Mention the Frontend IP address name | `string` | `"ise_lb_PrivateIPAddress"` |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | Enter the Github URL of the repo hosting the Function App code | `string` | `""` |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | This token will be used to read the Github code having Repo and Workflow access | `string` | `""` |
| <a name="input_ise_func_subnet"></a> [ise\_func\_subnet](#input\_ise\_func\_subnet) | Mention the subnet name for Function App VNET integration, it is a service dedicated subnet delegated to service Microsoft.Web/serverFarms. | `string` | `"ise_func_subnet"` |
| <a name="input_ise_image_sku"></a> [ise\_image\_sku](#input\_ise\_image\_sku) | ISE image sku - available values -  cisco-ise\_3\_2,  cisco-ise\_3\_3 & cisco-ise\_3\_4 | `string` | `"cisco-ise_3_2"` |
| <a name="input_ise_image_version"></a> [ise\_image\_version](#input\_ise\_image\_version) | ISE image version - available versions: 3.2.543, 3.3.430 & 3.4.608 | `string` | `"3.2.543"` |
| <a name="input_ise_lb_backend_address_pool_name"></a> [ise\_lb\_backend\_address\_pool\_name](#input\_ise\_lb\_backend\_address\_pool\_name) | Mention the name for ISE Loadbalancer backend pool | `string` | `"ise-BackendAddressPool"` |
| <a name="input_ise_lb_name"></a> [ise\_lb\_name](#input\_ise\_lb\_name) | Provide the Loadbalancer name | `string` | `"ise-int-loadbalancer"` |
| <a name="input_ise_lb_sku"></a> [ise\_lb\_sku](#input\_ise\_lb\_sku) | Mention the Loadbalancer SKU | `string` | `"Standard"` |
| <a name="input_ise_lb_subnet_name"></a> [ise\_lb\_subnet\_name](#input\_ise\_lb\_subnet\_name) | Mention the subnet name for Loadbalancer | `string` | `"ps-prod-snet-app1"` |
| <a name="input_ise_offer"></a> [ise\_offer](#input\_ise\_offer) | Image Offer | `string` | `"cisco-ise-virtual"` |
| <a name="input_ise_pan_node_names"></a> [ise\_pan\_node\_names](#input\_ise\_pan\_node\_names) | Mention the hostname for ISE PAN Primary and Secondary nodes | `list(string)` | <pre>[<br>  "ise-pan-primary",<br>  "ise-pan-secondary"<br>]</pre> |
| <a name="input_ise_plan_name"></a> [ise\_plan\_name](#input\_ise\_plan\_name) | Plan Name for using the Marketplace ISE image, available options - cisco-ise\_3\_2 cisco-ise\_3\_3 & cisco-ise\_3\_4 | `string` | `"cisco-ise_3_2"` |
| <a name="input_ise_plan_product"></a> [ise\_plan\_product](#input\_ise\_plan\_product) | Value of Image Offer for using inside VM resource plan block | `string` | `"cisco-ise-virtual"` |
| <a name="input_ise_psn_node_names"></a> [ise\_psn\_node\_names](#input\_ise\_psn\_node\_names) | Mention the hostname for ISE PSN nodes | `list(string)` | <pre>[<br>  "ise-psn-node-1",<br>  "ise-psn-node-2"<br>]</pre> |
| <a name="input_ise_publisher"></a> [ise\_publisher](#input\_ise\_publisher) | Name of the Image publisher | `string` | `"cisco"` |
| <a name="input_ise_resource_group"></a> [ise\_resource\_group](#input\_ise\_resource\_group) | Mention the Resource Group name | `string` | `"ise-resource-group"` |
| <a name="input_ise_vm_adminuser_name"></a> [ise\_vm\_adminuser\_name](#input\_ise\_vm\_adminuser\_name) | ISE admin username | `string` | `"iseadmin"` |
| <a name="input_ise_vm_subnet_name"></a> [ise\_vm\_subnet\_name](#input\_ise\_vm\_subnet\_name) | Mention the subnet name for Virtual Machine/ ISE nodes | `string` | `"ps-prod-snet-app2"` |
| <a name="input_ise_vm_vm_sa_caching"></a> [ise\_vm\_vm\_sa\_caching](#input\_ise\_vm\_vm\_sa\_caching) | n/a | `string` | `"ReadWrite"` |
| <a name="input_ise_vm_vm_storage_account_type"></a> [ise\_vm\_vm\_storage\_account\_type](#input\_ise\_vm\_vm\_storage\_account\_type) | Disk storage type | `string` | `"Premium_LRS"` |
| <a name="input_ise_vnet_dns_link_name"></a> [ise\_vnet\_dns\_link\_name](#input\_ise\_vnet\_dns\_link\_name) | Provide the name for VNET link to associate with the Provide DNS zone | `string` | `"ise_vnet_dns_link"` |
| <a name="input_location"></a> [location](#input\_location) | Mention the region where you want to deploy resources | `string` | `"East US"` |
| <a name="input_marketplace_ise_image_agreement"></a> [marketplace\_ise\_image\_agreement](#input\_marketplace\_ise\_image\_agreement) | If ISE marketplace image agreement is already done set the value to 'true' else set it as 'false'. You can check the status by executing the Azure CLI command - 'az vm image terms show --publisher cisco  --offer cisco-ise-virtual --plan cisco-ise\_3\_2' | `bool` | `false` |
| <a name="input_marketplace_ise_image_agreement_psn"></a> [marketplace\_ise\_image\_agreement\_psn](#input\_marketplace\_ise\_image\_agreement\_psn) | If ISE marketplace image agreement is already done set the value to 'true' else set it as 'false'. You can check the status by executing the Azure CLI command - 'az vm image terms show --publisher cisco  --offer cisco-ise-virtual --plan cisco-ise\_3\_2' | `bool` | `true` |
| <a name="input_ntpserver"></a> [ntpserver](#input\_ntpserver) | Enter the IPv4 address or FQDN of the NTP server that must be used for synchronization, for example, time.nist.gov. | `string` | `"time.google.com"` |
| <a name="input_openapi"></a> [openapi](#input\_openapi) | Enter yes to enable OpenAPI, or no to disallow OpenAPI. | `string` | `"yes"` |
| <a name="input_password"></a> [password](#input\_password) | Configure a password for GUI-based login to Cisco ISE. The password that you enter must comply with the Cisco ISE password policy. The password must contain 6 to 25 characters and include at least one numeral, one uppercase letter, and one lowercase letter. The password cannot be the same as the username or its reverse (iseadmin or nimdaesi), cisco, or ocsic. The allowed special characters are @~*!,+=\_-. | `string` | `"C!sc0Ind1@"` |
| <a name="input_primarynameserver"></a> [primarynameserver](#input\_primarynameserver) | Enter the IP address of the Primary name server. Only IPv4 addresses are supported | `string` | `"168.63.129.16"` |
| <a name="input_pxGrid"></a> [pxGrid](#input\_pxGrid) | Enter yes to enable pxGrid, or no to disallow pxGrid | `string` | `"yes"` |
| <a name="input_pxgrid_cloud"></a> [pxgrid\_cloud](#input\_pxgrid\_cloud) | Enter yes to enable pxGrid Cloud or no to disallow pxGrid Cloud. To enable pxGrid Cloud, you must enable pxGrid. If you disallow pxGrid, but enable pxGrid Cloud, pxGrid Cloud services are not enabled on launch. | `string` | `"yes"` |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | Add the Azure subscription ID | `string` | `"4af28428-fadd-42d1-ba1c-ba3eef6d4a6c"` |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Enter a timezone that is allowed by ISE nodes. For information on the supported timezone formats, refer to this documentation - https://www.cisco.com/c/en/us/td/docs/security/ise/3-3/cli_guide/b_ise_CLI_Reference_Guide_33/b_ise_CLIReferenceGuide_33_chapter_011.html?#wp2884933107 | `string` | `"UTC"` |
| <a name="input_virtual_machines_pan"></a> [virtual\_machines\_pan](#input\_virtual\_machines\_pan) | Specify the configuration for pan instance. It should follow below format where key is the hostname and values are instance attributes.<br>{<br>  hostname = {<br>    size = "<vm\_size>",<br>    storage = "<storage\_size>",<br>    services =  "<service\_1>,<service\_2>",<br>    roles = "<role\_1>,<role\_2>"<br>  }<br>} | <pre>map(object({<br>    size     = string<br>    storage  = number<br>    services = optional(string)<br>    roles    = optional(string, "SecondaryAdmin")<br>  }))</pre> | n/a |
| <a name="input_virtual_machines_psn"></a> [virtual\_machines\_psn](#input\_virtual\_machines\_psn) | Specify the configuration for PSN instance. It should follow below format where key is the hostname and values are instance attributes.<br>{<br>  hostname = {<br>    size = "<vm\_size>",<br>    storage = "<storage\_size>",<br>    services =  "<service\_1>,<service\_2>",<br>    roles = "<MnT\_role>"<br>  }<br>} | <pre>map(object({<br>    size     = string<br>    storage  = number<br>    services = optional(string, "Session, Profiler") #string<br>    roles    = optional(string)<br>  }))</pre> | n/a |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Mention the Virtual Network (VNET) name | `string` | `"ps-prod-vnet"` |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer_frontendIP"></a> [loadbalancer\_frontendIP](#output\_loadbalancer\_frontendIP) | Loadbalancer Private IP Address |
| <a name="output_pan_node_name"></a> [pan\_node\_name](#output\_pan\_node\_name) | PAN node hostname |
| <a name="output_pan_private_ip_address"></a> [pan\_private\_ip\_address](#output\_pan\_private\_ip\_address) | PAN node Private IP Address |
| <a name="output_private_dns_records"></a> [private\_dns\_records](#output\_private\_dns\_records) | ISE node FQDN  |
| <a name="output_psn_node_name"></a> [psn\_node\_name](#output\_psn\_node\_name) | PSN node hostnames |
| <a name="output_psn_private_ip_address"></a> [psn\_private\_ip\_address](#output\_psn\_private\_ip\_address) | PAN node Private IP Address  |

