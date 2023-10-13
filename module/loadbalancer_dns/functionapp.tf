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

resource "azurerm_source_control_token" "external_repo_token" {
  type  = "GitHub"
  token = var.github_token
}

resource "azurerm_log_analytics_workspace" "ise_log_workspace" {
  name                = "workspace-test"
  location            = var.location
  resource_group_name = var.ise_resource_group
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "func-appinsights" {
  name                = "func-appinsights" # Replace with your desired Application Insights name
  resource_group_name = var.ise_resource_group
  location            = var.location
  workspace_id        = azurerm_log_analytics_workspace.ise_log_workspace.id
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

  app_settings = {
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

  lifecycle {
    ignore_changes = [site_config, app_settings]
  }

}


# Configuring Github source_control

resource "null_resource" "run_az_cli" {
  provisioner "local-exec" {
    command = "az functionapp deployment source config --branch main --manual-integration --name  ${azurerm_linux_function_app.ise-function-app.name} --repo-url ${var.github_repo} --resource-group ${var.ise_resource_group}"
  }
}


# Creating App Configuration

resource "azurerm_app_configuration" "ise_appconf" {
  name                = "ise-appconf-${random_string.function_app_suffix.result}"
  resource_group_name = var.ise_resource_group
  location            = var.location
}


# Creating Key-Value paramter and storing them in App Configuration

resource "azurerm_app_configuration_key" "kv_pan_ip" {
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  for_each               = local.combined_key_value
  key                    = each.key
  #label    = "pan"
  value = data.azurerm_virtual_machine.ise_vm_nic_ip[each.value].private_ip_address

}


resource "azurerm_app_configuration_key" "kv_pan_fqdn" {
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  for_each               = local.combined_pan_kv_fqdn
  key                    = each.key
  #label                  = "pan"
  value = trimsuffix(azurerm_private_dns_a_record.ise_vm_dns_record[each.value].fqdn, ".")

}

resource "azurerm_app_configuration_key" "kv_psn_fqdn" {
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  for_each               = local.combined_psn_kv_fqdn
  key                    = "${each.key}-fqdn"
  label                  = "psn"
  value                  = trimsuffix(azurerm_private_dns_a_record.ise_vm_dns_record[each.value].fqdn, ".")

}


resource "azurerm_app_configuration_key" "kv_username_password" {
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  for_each               = local.combined_user_password_kv
  key                    = each.key
  value                  = each.value

}
