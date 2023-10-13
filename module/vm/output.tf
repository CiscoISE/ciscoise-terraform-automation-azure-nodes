
output "private_address" {
  value = [for private_ip in azurerm_linux_virtual_machine.ise_vm : private_ip.private_ip_address]
}

output "node_name" {
  value = [for node_name in azurerm_linux_virtual_machine.ise_vm : node_name.name]
}