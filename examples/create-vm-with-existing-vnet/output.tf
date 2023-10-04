output "pan_private_ip_address" {
  value = module.ise_pan_vm_cluster.private_address
}

output "psn_private_ip_address" {
  value = module.ise_psn_vm_cluster.private_address
}

output "psn_node_name" {
  value = module.ise_psn_vm_cluster.node_name
}

output "pan_node_name" {
  value = module.ise_pan_vm_cluster.node_name
}

# output "pan_node_detail" {
#   value = join(":", [module.ise_pan_vm_cluster.node_name, module.ise_pan_vm_cluster.private_address])
# }

# output "psn_node_detail" {
#   value = join(":", [module.ise_psn_vm_cluster.node_name, module.ise_psn_vm_cluster.private_address])
# }