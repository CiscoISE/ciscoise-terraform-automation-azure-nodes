# Copyright 2024 Cisco Systems, Inc. and its affiliates
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

data "azurerm_subnet" "ise_func_subnet" {
  name                 = var.ise_func_subnet
  virtual_network_name = var.vnet_name
  resource_group_name  = var.ise_resource_group
}


resource "azurerm_storage_account" "ise-app-storage" {
  name                            = "iseappstorage${random_string.function_app_suffix.result}"
  resource_group_name             = var.ise_resource_group
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
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
  count = var.github_token == "" ? 0 : 1
  type  = "GitHub"
  token = var.github_token
}

resource "azurerm_log_analytics_workspace" "ise_log_workspace" {
  name                = "workspace-ise"
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
  name                          = "ise-function-app-${random_string.function_app_suffix.result}"
  location                      = var.location
  resource_group_name           = var.ise_resource_group
  service_plan_id               = azurerm_service_plan.ise-asp.id
  storage_account_name          = azurerm_storage_account.ise-app-storage.name
  storage_account_access_key    = azurerm_storage_account.ise-app-storage.primary_access_key
  virtual_network_subnet_id     = data.azurerm_subnet.ise_func_subnet.id
  public_network_access_enabled = false

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = true
    "AzureWebJobsStorage"                    = azurerm_storage_account.ise-app-storage.primary_connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"         = azurerm_application_insights.func-appinsights.instrumentation_key
    "AppConfigConnectionString"              = azurerm_app_configuration.ise_appconf.primary_read_key[0].connection_string
    "AzureFunctionsJobHost__functionTimeout" = "04:00:00"
  }

  site_config {
    always_on = true
    application_stack {
      python_version = "3.10"
    }
  }

  lifecycle {
    ignore_changes = [site_config, app_settings, tags]
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
  sku                 = "standard"
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
  label                  = "psn_fqdn"
  value                  = trimsuffix(azurerm_private_dns_a_record.ise_vm_dns_record[each.value].fqdn, ".")

}


resource "azurerm_app_configuration_key" "kv_username_password" {
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  for_each               = local.combined_user_password_kv
  key                    = each.key
  value                  = each.value

}

# Storing Azure function HTTP trigger function endpoint in App conf

resource "azurerm_app_configuration_key" "function_url" {
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  key                    = "function_url"
  value                  = "https://${azurerm_linux_function_app.ise-function-app.name}.azurewebsites.net/api/HttpTrigger1"

}


# PSN services paramater - Testing

resource "azurerm_app_configuration_key" "kv_psn_services" {
  for_each               = var.virtual_machines_psn
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  key                    = "${each.key}-services"
  label                  = "psn_services"
  value                  = each.value.services
}

# PSN roles parameter

resource "azurerm_app_configuration_key" "kv_psn_roles" {
  for_each               = var.virtual_machines_psn
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  key                    = "${each.key}-roles"
  label                  = "psn_roles"
  value                  = each.value.roles
}


# PAN roles parameter

resource "azurerm_app_configuration_key" "kv_pan_roles" {
  for_each               = var.virtual_machines_pan
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  key                    = "${each.key}-roles"
  label                  = "pan_roles"
  value                  = each.value.roles
}


# PAN services parameter


resource "azurerm_app_configuration_key" "kv_pan_services" {
  for_each               = var.virtual_machines_pan
  configuration_store_id = azurerm_app_configuration.ise_appconf.id
  key                    = "${each.key}-services"
  label                  = "pan_services"
  value                  = each.value.services
}