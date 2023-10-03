data "azurerm_subnet" "ise_func_subnet" {
  name                 = var.ise_func_subnet
  virtual_network_name = var.vnet_name
  resource_group_name  = var.ise_resource_group
}



resource "azurerm_storage_account" "ise-app-storage" {
  name                     = "iseappstorage${random_string.function_app_suffix.result}"
  resource_group_name      = var.ise_resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "function_app_suffix" {
  length      = 4
  special     = false
  upper       = false
  numeric     = true
  min_upper   = 0
  min_numeric = 0
}

resource "azurerm_application_insights" "func-appinsights" {
  name                = "func-appinsights" # Replace with your desired Application Insights name
  resource_group_name = var.ise_resource_group
  location            = var.location
  application_type    = "web"
}

resource "azurerm_service_plan" "ise-asp" {
  name                = "ise-asp"
  location            = var.location
  resource_group_name = var.ise_resource_group
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "ise-function-app" {
  name                       = "ise-function-app-${random_string.function_app_suffix.result}"
  location                   = var.location
  resource_group_name        = var.ise_resource_group
  service_plan_id            = azurerm_service_plan.ise-asp.id
  storage_account_name       = azurerm_storage_account.ise-app-storage.name
  storage_account_access_key = azurerm_storage_account.ise-app-storage.primary_access_key
  virtual_network_subnet_id  = data.azurerm_subnet.ise_func_subnet.id
  zip_deploy_file = "${path.module}/panpsn.zip"


  app_settings = {
    # "FUNCTIONS_WORKER_RUNTIME" = "python"
    #  "FUNCTIONS_EXTENSION_VERSION" = "~4"
   # "WEBSITE_RUN_FROM_PACKAGE" = 1
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = true
    "AzureWebJobsStorage"            = azurerm_storage_account.ise-app-storage.primary_connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.func-appinsights.instrumentation_key
    "AppConfigConnectionString"      = azurerm_app_configuration.ise_appconf.primary_read_key[0].connection_string
  }

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }

  #   connection_string {
  #     name  = "AzureWebJobsStorage"
  #     type  = "Custom"
  #     value = azurerm_storage_account.ise-app-storage.primary_connection_string
  #   }
}


# Integrating VNET with the Function App

# resource "azurerm_app_service_virtual_network_swift_connection" "func_vnet_int" {
#   app_service_id = azurerm_linux_function_app.ise-function-app.id
#   subnet_id      = data.azurerm_subnet.ise_func_subnet.id
# }


# resource "azurerm_app_service_source_control" "external_repo" {
#   app_id   = azurerm_linux_function_app.ise-function-app.id
#   repo_url = "https://github.com/ro6it/ise-node-setup.git"
#   branch   = "main"
# }

# resource "azurerm_app_service_source_control_token" "external_repo_token" {
#   type  = "GitHub"
#   token = "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"
# }

#https://ro6it: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@github.com/ro6it/ise-node-setup.git

# Creating App Configuration


resource "azurerm_app_configuration" "ise_appconf" {
  name                = "appConfISE"
  resource_group_name = var.ise_resource_group
  location            = var.location
}

#data "azurerm_client_config" "current" {}

# resource "azurerm_role_assignment" "appconf_dataowner" {
#   scope                = azurerm_app_configuration.ise_appconf.id
#   role_definition_name = "App Configuration Data Owner"
#   principal_id         = "fb543ab5-89bd-4b33-ad65-19c581ca29dc"
# }

# resource "azurerm_app_configuration_key" "test" {
#   configuration_store_id = azurerm_app_configuration.ise_appconf.id
#   for_each = { for pair in local.key_value_pairs : "${pair[0]}-${pair[1]}" => pair}
#   key                    = each.value[1]
#   label                  = "test"
#   value                  = data.azurerm_virtual_machine.ise_vm_nic_ip[each.value[0]].private_ip_address
#   # depends_on = [
#   #   azurerm_role_assignment.appconf_dataowner
#   # ]
# }


# resource "azurerm_app_configuration_key" "kv_pan_ip" {
#   configuration_store_id = azurerm_app_configuration.ise_appconf.id
#    #for_each = { for pair in local.key_value_pairs : "${pair[0]}-${pair[1]}" => pair}
#   #for_each = { for item in local.combined_set : item => item }
#   for_each = local.combined_key_value
#   key                    = each.key
#   label                  = "test"
#   value                  = data.azurerm_virtual_machine.ise_vm_nic_ip[each.value].private_ip_address
#   depends_on = [
#     azurerm_role_assignment.appconf_dataowner
#   ]
# }


# resource "azurerm_app_configuration_key" "kv_pan_fqdn" {
#   configuration_store_id = azurerm_app_configuration.ise_appconf.id
#    #for_each = { for pair in local.key_value_pairs : "${pair[0]}-${pair[1]}" => pair}
#   #for_each = { for item in local.combined_set : item => item }
#   for_each = local.combined_pan_kv_fqdn
#   key                    = each.key
#   label                  = "test"
#   value                  = azurerm_private_dns_a_record.ise_vm_dns_record[each.value].fqdn
# #   depends_on = [
# #     azurerm_role_assignment.appconf_dataowner
# #   ]
# }


# locals {
#   ise_node_name = var.ise_node_names
#   appConIP = var.appConIP
#   pan_node = var.ise_pan_node_names
#  # key_value_pairs = setproduct(local.pan_node, local.appConIP)
#   #combined_set = setunion(local.appConIP, local.pan_node)
#   combined_key_value = zipmap(local.appConIP, local.pan_node)
# appConfqdn = var.appConfqdn
# combined_pan_kv_fqdn = zipmap(local.appConfqdn, local.pan_node)
# }