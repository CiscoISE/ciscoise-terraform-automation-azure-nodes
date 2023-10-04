output "ise-vm-backendpool" {
  value = azurerm_lb_backend_address_pool.ise-vm-backendpool.id
}

# output "ise_vm_private_dns_zone" {
#   value = azurerm_virtual_machine.ise_vm_nic_ip[*].private_ip_address
# }


output "private_dns_records" {
  value = [ for ise_fqdn in azurerm_private_dns_a_record.ise_vm_dns_record : ise_fqdn.fqdn ]
}

# output "node_name" {
#   value = [ for node_name in azurerm_linux_virtual_machine.ise_vm : node_name.name ]
# }

output "loadbalancer_frontendIP" {
  value = azurerm_lb.ise-lb.private_ip_address
}