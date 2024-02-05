locals {
  ise_pan_node_names = keys(var.virtual_machines_pan)
  ise_psn_node_names = keys(var.virtual_machines_psn)

  # roles_pan = flatten([for vm in values(var.virtual_machines_pan) : vm.roles != null ? [vm.roles] : []])
  # roles_psn = flatten([for vm in values(var.virtual_machines_psn) : vm.roles != null ? [vm.roles] : []])
  roles_psn = compact(flatten([for vm in values(var.virtual_machines_psn) : split(", ", vm.roles) if vm.roles != null]))
  roles_pan = compact(flatten([for vm in values(var.virtual_machines_pan) : split(", ", vm.roles) if vm.roles != null]))
  roles_set = concat(local.roles_pan, local.roles_psn)
  roles     = local.roles_set
}