output "ise-vm-backendpool" {
  value = azurerm_lb_backend_address_pool.ise-vm-backendpool.id
}

# output "ise_vm_private_dns_zone" {
#   value = azurerm_virtual_machine.ise_vm_nic_ip[*].private_ip_address
# }