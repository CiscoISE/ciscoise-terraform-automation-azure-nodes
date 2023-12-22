# output "pan_private_ip_address" {
#   value = module.ise_pan_vm_cluster.private_address
# }

output "pan_ip" {
  value = [for private_ip in module.ise_pan_vm_cluster : private_ip.private_address]

}

output "psn_ip" {
  value = [for private_ip in module.ise_psn_vm_cluster : private_ip.private_address]

}

# output "psn_private_ip_address" {
#   value = module.ise_psn_vm_cluster.private_address
# }

# output "psn_node_name" {
#   value = module.ise_psn_vm_cluster.node_name
# }

# output "psn_node_name" {
#    value = [ for vm_name, _ in module.ise_psn_vm_cluster : vm_name]
# }

# output "pan_node_name" {
#   value = module.ise_pan_vm_cluster.node_name
# }
output "pan_name" {
  value = [for pan_name in module.ise_pan_vm_cluster : pan_name.node_name]
}

output "psn_name" {
  value = [for psn_name in module.ise_psn_vm_cluster : psn_name.node_name]
}

output "private_dns_records" {
  value = module.loadbalancer_dns.private_dns_records
}

output "loadbalancer_frontendIP" {
  value = module.loadbalancer_dns.loadbalancer_frontendIP
}

# output "roles_debug" {
#   value = jsonencode(local.roles)
# }

output "var_test" {
  value = var.virtual_machines_psn
}

output "roles" {
  value = local.roles
}