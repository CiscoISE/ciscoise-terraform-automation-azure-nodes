availability_zone_pan  = "1"
availability_zone_psn  = "2"
disk_size              = 600
dnsdomain              = "example.com"
ersapi                 = "yes"
frontend_ip_allocation = "Dynamic"
frontend_lb_ip_name    = "ise_lb_PrivateIPAddress"
ise_func_subnet        = "ise_func_subnet"
ise_func_subnet_cidr = [
  "10.0.14.0/26"
]
ise_image_sku                    = "cisco-ise_3_2"
ise_image_version                = "3.2.543"
ise_lb_backend_address_pool_name = "ise-BackendAddressPool"
ise_lb_name                      = "ise-int-loadbalancer"
ise_lb_sku                       = "Standard"
ise_offer                        = "cisco-ise-virtual"
ise_pan_node_names = [
  "ise-pan-primary",
  "ise-pan-secondary"
]
ise_plan_name    = "cisco-ise_3_2"
ise_plan_product = "cisco-ise-virtual"
ise_psn_node_names = [
  "ise-psn-node-1",
  "ise-psn-node-2"
]
ise_publisher                       = "cisco"
ise_resource_group                  = "Cisco_ISE_RG"
ise_vm_adminuser_name               = "iseadmin"
ise_vm_size_sku                     = "Standard_B2ms"
ise_vm_size_sku_psn                 = "Standard_B2ms"
ise_vm_vm_sa_caching                = "ReadWrite"
ise_vm_vm_storage_account_type      = "Premium_LRS"
ise_vnet_dns_link_name              = "ise_vnet_dns_link"
location                            = "East US"
marketplace_ise_image_agreement     = false
marketplace_ise_image_agreement_psn = true
ntpserver                           = "time.google.com"
openapi                             = "yes"
password                            = "C!sc0Ind1@"
primarynameserver                   = "168.63.129.16"
private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24",
  "10.0.13.0/24"
]
public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]
pxGrid       = "yes"
pxgrid_cloud = "yes"
subscription = "4af28428-fadd-42d1-ba1c-ba3eef6d4a6c"
timezone     = "UTC"
vnet_address = "10.0.0.0/16"
vnet_name    = "ise_vnet"
