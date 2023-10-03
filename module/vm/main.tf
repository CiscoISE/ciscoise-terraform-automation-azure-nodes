/* https://learn.microsoft.com/en-us/marketplace/programmatic-deploy-of-marketplace-products  */
/* https://stackoverflow.com/questions/74887620/how-to-use-in-terraform-an-image-from-azure-marketplace */

data "azurerm_virtual_network" "ise_vnet" {
  name                = var.vnet_name
  resource_group_name = var.ise_resource_group
}

data "azurerm_subnet" "ise_vm_subnet" {
  name                 = var.ise_vm_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.ise_resource_group
}


resource "azurerm_marketplace_agreement" "cisco_ise_marketplace_agrmt" {
  count = var.marketplace_ise_image_agreement ? 0 : 1
  publisher = var.ise_publisher
  offer     = var.ise_offer
  plan      = var.ise_plan_name
}

# resource "azurerm_availability_set" "ise_availability_set" {
#   name                         = "ise_availability_set"
#   location                     = var.location
#   resource_group_name          = var.ise_resource_group
#   platform_fault_domain_count  = 3
#   platform_update_domain_count = 3
# }

resource "azurerm_network_interface" "ise_vm_nic" {
  for_each            = toset(local.ise_node_name)
  name                = "${each.key}-nic" #"ise-vm-nic-${count.index}"
  location            = var.location
  resource_group_name = var.ise_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.ise_vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  
}

# locals {
#   ise_node_name = [
#     "ise-pan-primary",
#     "ise-pan-secondary"
#   ]
# }

locals {
  ise_node_name = var.ise_node_names
}


# locals {
#   ise_node_name = [
#     "ise-pan-primary",
#     "ise-pan-secondary"
#   ]
#   ise_psn_node = [
#     "ise-psn-node-1",
#     "ise-psn-node-2",
#     "ise-psn-node-3",
#     "ise-psn-node-4"
#   ]
# }

resource "azurerm_linux_virtual_machine" "ise_vm" {
  for_each            = toset(local.ise_node_name)
  name                = each.key
  resource_group_name = var.ise_resource_group
  location            = var.location
  size                = var.ise_vm_size_sku
  admin_username      = var.ise_vm_adminuser_name
  zone                = var.availability_zone
  user_data = base64encode(templatefile("${path.module}/user_data.tftpl", {
    hostname          = each.key
    primarynameserver = var.primarynameserver
    dnsdomain         = var.dnsdomain
    ntpserver         = var.ntpserver
    timezone          = var.timezone
    password          = var.password
    ersapi            = var.ersapi
    openapi           = var.openapi
    pxGrid            = var.pxGrid
    pxgrid_cloud      = var.pxgrid_cloud
  }))
  #availability_set_id = azurerm_availability_set.ise_availability_set.id

  network_interface_ids = [
    #azurerm_network_interface.ise_vm_nic[count.index].id,
    azurerm_network_interface.ise_vm_nic[each.key].id
  ]

  admin_ssh_key {
    username   = var.ise_vm_adminuser_name
    public_key = file("${path.module}/isekey.pub")
  }

  source_image_reference {
    publisher = var.ise_publisher
    offer     = var.ise_offer
    sku       = var.ise_image_sku
    version   = var.ise_image_version
  }
  plan {
    name      = var.ise_plan_name
    publisher = var.ise_publisher
    product   = var.ise_plan_product
  }

  os_disk {
    storage_account_type = var.ise_vm_vm_storage_account_type
    caching              = var.ise_vm_vm_sa_caching
    disk_size_gb         = var.disk_size
  }

  # depends_on = [
  #   azurerm_marketplace_agreement.cisco_ise_marketplace_agrmt
  # ]
}
