locals {
  appConIP                  = var.appConIP
  pan_node                  = keys(var.virtual_machines_pan)
  psn_node                  = keys(var.virtual_machines_psn)
  ise_node_name             = concat(local.pan_node, local.psn_node)
  combined_key_value        = zipmap(local.appConIP, local.pan_node)
  appConfqdn                = var.appConfqdn
  combined_pan_kv_fqdn      = zipmap(local.appConfqdn, local.pan_node)
  combined_psn_kv_fqdn      = zipmap(local.psn_node, local.psn_node)
  username_password_key     = var.username_password_key
  username_password_value   = [var.ise_vm_adminuser_name, var.password]
  combined_user_password_kv = zipmap(local.username_password_key, local.username_password_value)
}