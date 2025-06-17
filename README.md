[![ISE VERSION](https://img.shields.io/badge/ISE%20SUPPORTED%20VERSIONS-3.2%20,3.3%20AND%203.4-blue?style=for-the-badge&logo=cisco)](#)
[![Terraform Azure](https://img.shields.io/badge/IaC-Terraform-blue?style=for-the-badge&logo=terraform)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
[![Azure](https://img.shields.io/badge/Cloud-Azure-blue?style=for-the-badge&logo=microsoftazure)](https://azure.microsoft.com/)
[![Python](https://img.shields.io/badge/AZURE%20FUNCTION%20APP-Python-3572A5?style=for-the-badge)](https://github.com/CiscoISE/ciscoise-terraform-automation-azure-functions)

# Automated ISE setup with Infrastructure as Code using Terraform on Azure

1. This project runs terraform module to deploy upto 58 ISE nodes(min:2 | max:58) on Azure based on User Input.
2. It deploys the required Infrastructure and configure ISE nodes as per User Input.

## ISE Supported Versions
- 3.2
- 3.3
- 3.4

## Requirements
- Terraform ~> 1.5.x
- Azure CLI
- Azure subscription with at least `Contributor` level access and `App Configuration Data Owner` role assigned.


## Installations

1. To install terraform, follow the instructions as per your operating system - [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)

2. To install Azure CLI, follow the instructions mentioned here - [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)


  
## Configuration and Authentication using Azure CLI

To configure and allow access to Azure account, we need a user having atleast `Contributor` level access . Run the below command to get Azure access using CLI. It will prompt you to login through web browser
```
az login
```

In case you are running this command on a server where you don't have any browser you can run the below command and use the code to login on any other machine.
```
az login --use-device-code
```

To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code to authenticate.

`NOTE:` Please refer Terraform documentation for other authentication methods. -  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs



## Prerequisites

1. Setup SSH for git, follow this documentation - [How to setup SSH for git](https://www.warp.dev/terminus/git-clone-ssh) 
2. Create a SSH key pair for ISE Virtual Machine - [Create SSH key pair](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed)
3. Check ISE image subscription status for Azure marketplace agreement acceptance and ISE VM image version details - [Refer here](./docs/azure-cli-commands.md)
4. ( :exclamation: `IMPORTANT` )- This ISE setup is being deployed in the high availability so please make sure the `region` selected to deploy the ISE VM supports the `Availability zones`. [Regions that support availability zone](https://azure.microsoft.com/en-gb/explore/global-infrastructure/geographies/#geographies)
5. For existing VNET setup: 3 Private Subnets - (2 subnets for deploying VM and Loadbalancer and, 1 - subnet delegated to service Microsoft.Web/serverFarms  for Function App VNET integration)
6. As per Terraform's best practice, it is recommended to store the state file remotely in cloud. As Storing terraform state files in storage account provides enhanced collaboration, security and durability over keeping state files locally.
- If you have a Azure storage account already created to store the state file, that needs to be referenced in terraform init command. 
- If you do not have an existing storage account then please create Azure storage account configuration which needs to be referenced in terraform init command.

Run below commands to configure storage account
```
az group create --name myResourceGroup --location eastus

az storage account create --name mystorageaccount --resource-group myResourceGroup --location eastus --sku Standard_LRS

az storage account show-connection-string --name mystorageaccount --resource-group myResourceGroup --query connectionString --output tsv

az storage container create --name mycontainer --connection-string "<your_connection_string>"
```
  
   


## Terraform module structure

To refer the detailed structure of this terraform module, check here - [Module structure](./docs/directory-structure.md)



## Run terraform modules

Clone this git repo by using below this command

```
git clone https://github.com/CiscoISE/ciscoise-terraform-automation-azure-nodes.git
```
  

Choose one of the following options to setup ISE infra

### 1. Deploy using an existing VNET
  
To deploy using an existing VNET

```
cd examples/create-vm-with-existing-vnet
```

Here, we are using Azure CLI for authentication and configure Terraform to use a specific `Subscription` by specifying it's value in `terraform.tfvars` file for variable named as `subscription`.

  Refer [create-vm-with-existing-vnet README](./examples/create-vm-with-existing-vnet/README.md) and update the variables in `terraform.tfvars` and follow the steps.



### 2. Deploy using a new VNET

To deploy using a new VNET 

```
cd examples/create-vm-with-new-vnet
```

Here, we are using Azure CLI for authentication and configure Terraform to use a specific `Subscription` by specifying it's value in `terraform.tfvars` file for variable named as `subscription`.

  Refer [create-vm-with-new-vnet README](./examples/create-vm-with-new-vnet/README.md) and update the variables in `terraform.tfvars` and follow the steps.

`NOTE:` All the ISE resources reside in the private subnet within the VNET. The associated network security group (NSG) uses default rules that allow all inbound and outbound traffic within the VNET on all ports/protocol. In order to restrict the inbound/outbound traffic to ISE specific ports, please make the specific changes in the assigned NSG to allow necessary communication.

## Destroy Infrastructure

To destroy the ISE infrastructure resources created by this module, run below commands.

`NOTE:`
Manual changes/resource creation outside this terrform module will not be tracked in the terraform state and cause issues if user needs to upgrade/destory the deployed stack. Please avoid manual changes. 
If still manual changes are needed then please keep a note of changes, revert them before making any upgrade or destroy.

```
terraform destroy -plan
terraform destroy
``` 
To know more about the destroy command, please refer this [terraform destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy) page

If you encounter issues with the `terraform destroy` command, attempt to run the command again. Additionally, you can track the resources managed by Terraform using the following command

```
terraform state list
```
