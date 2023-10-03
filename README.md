# Automated ISE setup with Infrastructure as Code using Terraform on Azure

This project runs terraform module to setup ISE infrastructure on Azure Cloud Platform.

## Requirements
- Terraform ~> 1.5.x
- Azure CLI
- Azure subscription with atleast Contributor level access.

## Installations
1. To install terraform, follow the instructions as per your operating system - [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)

2. To install Azure CLI, follow the instructions mentioned here - [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Configure Azure CLI
To configure and allow access to Azure account, we need a user having atleast `Contributor` level access . Run the below command to get Azure access using CLI. It will prompt you to login through web browser

```
az login 
```

In case you are running this command on a server where you don't have any browser you can run the below command and use the code to login on any other machine.

```
az login --use-device-code
```
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code  to authenticate.

##  Authenticating using the Azure CLI

We recommend using either a Service Principal or Managed Service Identity when running Terraform non-interactively (such as when running Terraform in a CI server) - and authenticating using the Azure CLI when running Terraform locally. 
Please refer Terraform documentation for other authentication methods.
Documentation - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

## Run terraform modules

Clone this git repo by using below this command 
  ```
  git clone https://github3.cisco.com/techops-operation/ise_launch_template-terraform-azure-vm.git
  ```

Choose on of the following options to setup ISE infra
1. [Deploy using an existing VNET](./examples/create-vm-with-existing-vnet/)
2. [Deploy using a new VNET](./examples/create-vm-with-new-vnet/)

To deploy using an existing VNET
  ```
  cd examples/create-vm-with-existing-vnet
  ```

Here, we will be running it locally and will use Azure CLI for authentication and configure Terraform to use a specific `Subscription` by specifying it's value in `variables.tf` file for variable named as `subscription`

To deploy using a new VNET
```
cd examples/create-vm-with-new-vnet
```

Run below commands
 ```
 terraform init --upgrade
 terraform plan
 terraform apply
 ```

Type 'yes' when prompted after running terraform apply

After setting up ISE infra using terraform, it will take 45-60 minutes for the stack to deploy and ISE application to come up