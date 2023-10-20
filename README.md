# Automated ISE setup with Infrastructure as Code using Terraform on Azure

This project runs terraform module to setup ISE infrastructure on Azure Cloud Platform.

## Requirements
- Terraform ~> 1.5.x
- Azure CLI
- Azure subscription with at least `Contributor` level access and `App Configuration Data Owner` role assigned.

## Installations

1. To install terraform, follow the instructions as per your operating system - [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)

2. To install Azure CLI, follow the instructions mentioned here - [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

  
## Configuring and Authenticating using Azure CLI

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
3. Check ISE image subscription status for Azure marketplace agreement acceptance.
4. ISE VM image version details that you want to deploy: Available SKU options:- cisco-ise_3_2 and cisco-ise_3_3
5. ( `IMPORTANT` )- This ISE setup is being deployed in the high availability so please make sure the `region` selected to deploy the ISE VM supports the `Availability zones`. 
6. For existing VNET setup: 3 Private Subnets - (2 subnets for deploying VM and Loadbalancer and, 1 - subnet delegated to service Microsoft.Web/serverFarms  for Function App VNET integration)
  
Check for region that supports availability zone  - https://azure.microsoft.com/en-gb/explore/global-infrastructure/geographies/#geographies   

## Run terraform modules

Clone this git repo by using below this command

```
git clone https://github3.cisco.com/techops-operation/ise_launch_template-terraform-azure-vm.git
```
  

Choose one of the following options to setup ISE infra

1. [Deploy using an existing VNET](./examples/create-vm-with-existing-vnet/)
  
To deploy using an existing VNET

```
cd examples/create-vm-with-existing-vnet
```

Here, we are using Azure CLI for authentication and configure Terraform to use a specific `Subscription` by specifying it's value in `terraform.tfvars` file for variable named as `subscription`.

  Refer [create-vm-with-existing-vnet README](./examples/create-vm-with-existing-vnet/README.md) and update the variables in `terraform.tfvars`.


2. [Deploy using a new VNET](./examples/create-vm-with-new-vnet/)

To deploy using a new VNET

```
cd examples/create-vm-with-new-vnet
```

Here, we are using Azure CLI for authentication and configure Terraform to use a specific `Subscription` by specifying it's value in `terraform.tfvars` file for variable named as `subscription`.

  Refer [create-vm-with-new-vnet README](./examples/create-vm-with-new-vnet/README.md) and update the variables in `terraform.tfvars`.

  
After updating the `terraform.tfvars` file, run the below commands:

```
terraform init --upgrade
terraform plan
terraform apply
```

Type 'yes' when prompted after running terraform apply

After setting up ISE infra using terraform, it will take 45-60 minutes for the stack to deploy and ISE application to come up.