# ise_launch_template-terraform-azure-vm

```yaml
Terraform will perform the following actions:

  # azurerm_lb.ise-lb will be created
  + resource "azurerm_lb" "ise-lb" {
      + id                   = (known after apply)
      + location             = "eastus"
      + name                 = "ise-int-LoadBalancer"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "ise_dev"
      + sku                  = "Standard"
      + sku_tier             = "Regional"

      + frontend_ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + id                                                 = (known after apply)
          + inbound_nat_rules                                  = (known after apply)
          + load_balancer_rules                                = (known after apply)
          + name                                               = "ise_lb_PrivateIPAddress"
          + outbound_rules                                     = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = (known after apply)
          + public_ip_address_id                               = (known after apply)
          + public_ip_prefix_id                                = (known after apply)
          + subnet_id                                          = "/subscriptions/4af28428-fadd-42d1-ba1c-ba3eef6d4a6c/resourceGroups/ise_dev/providers/Microsoft.Network/virtualNetworks/esc_VNet/subnets/default"
        }
    }

  # azurerm_lb_backend_address_pool.ise-vmss-backendpool will be created
  + resource "azurerm_lb_backend_address_pool" "ise-vmss-backendpool" {
      + backend_ip_configurations = (known after apply)
      + id                        = (known after apply)
      + inbound_nat_rules         = (known after apply)
      + load_balancing_rules      = (known after apply)
      + loadbalancer_id           = (known after apply)
      + name                      = "ise-BackendAddressPool"
      + outbound_rules            = (known after apply)
    }

  # azurerm_lb_probe.ise_health_checks will be created
  + resource "azurerm_lb_probe" "ise_health_checks" {
      + id                  = (known after apply)
      + interval_in_seconds = 15
      + load_balancer_rules = (known after apply)
      + loadbalancer_id     = (known after apply)
      + name                = "https-probe"
      + number_of_probes    = 2
      + port                = 443
      + probe_threshold     = 1
      + protocol            = "Tcp"
    }

  # azurerm_lb_rule.ise-lb-rule-psn-1 will be created
  + resource "azurerm_lb_rule" "ise-lb-rule-psn-1" {
      + backend_address_pool_ids       = (known after apply)
      + backend_port                   = 1812
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "ise_lb_PrivateIPAddress"
      + frontend_port                  = 1812
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "ise-lb-rule-psn-1"
      + probe_id                       = (known after apply)
      + protocol                       = "Udp"
    }

  # azurerm_lb_rule.ise-lb-rule-psn-2 will be created
  + resource "azurerm_lb_rule" "ise-lb-rule-psn-2" {
      + backend_address_pool_ids       = (known after apply)
      + backend_port                   = 1813
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "ise_lb_PrivateIPAddress"
      + frontend_port                  = 1813
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "ise-lb-rule-psn-2"
      + probe_id                       = (known after apply)
      + protocol                       = "Udp"
    }

  # azurerm_lb_rule.ise-lb-rule-psn-3 will be created
  + resource "azurerm_lb_rule" "ise-lb-rule-psn-3" {
      + backend_address_pool_ids       = (known after apply)
      + backend_port                   = 49
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "ise_lb_PrivateIPAddress"
      + frontend_port                  = 49
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "ise-lb-rule-psn-3"
      + probe_id                       = (known after apply)
      + protocol                       = "Tcp"
    }

  # azurerm_lb_rule.ise-lb-rule-psn-4 will be created
  + resource "azurerm_lb_rule" "ise-lb-rule-psn-4" {
      + backend_address_pool_ids       = (known after apply)
      + backend_port                   = 1645
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "ise_lb_PrivateIPAddress"
      + frontend_port                  = 1645
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "ise-lb-rule-psn-4"
      + probe_id                       = (known after apply)
      + protocol                       = "Udp"
    }

  # azurerm_lb_rule.ise-lb-rule-psn-5 will be created
  + resource "azurerm_lb_rule" "ise-lb-rule-psn-5" {
      + backend_address_pool_ids       = (known after apply)
      + backend_port                   = 1646
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "ise_lb_PrivateIPAddress"
      + frontend_port                  = 1646
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "ise-lb-rule-psn-5"
      + probe_id                       = (known after apply)
      + protocol                       = "Udp"
    }

  # azurerm_lb_rule.ise-lb-rule-psn-gui will be created
  + resource "azurerm_lb_rule" "ise-lb-rule-psn-gui" {
      + backend_address_pool_ids       = (known after apply)
      + backend_port                   = 443
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "ise_lb_PrivateIPAddress"
      + frontend_port                  = 443
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "ise-lb-rule-psn-gui"
      + probe_id                       = (known after apply)
      + protocol                       = "Tcp"
    }

  # azurerm_linux_virtual_machine_scale_set.isevmss will be created
  + resource "azurerm_linux_virtual_machine_scale_set" "isevmss" {
      + admin_username                                    = "iseadmin"
      + computer_name_prefix                              = (known after apply)
      + disable_password_authentication                   = true
      + do_not_run_extensions_on_overprovisioned_machines = false
      + extension_operations_enabled                      = (known after apply)
      + extensions_time_budget                            = "PT1H30M"
      + health_probe_id                                   = (known after apply)
      + id                                                = (known after apply)
      + instances                                         = 1
      + location                                          = "eastus"
      + max_bid_price                                     = -1
      + name                                              = "ise-vmss"
      + overprovision                                     = true
      + platform_fault_domain_count                       = (known after apply)
      + priority                                          = "Regular"
      + provision_vm_agent                                = true
      + resource_group_name                               = "ise_dev"
      + scale_in_policy                                   = (known after apply)
      + single_placement_group                            = true
      + sku                                               = "Standard_B2ms"
      + unique_id                                         = (known after apply)
      + upgrade_mode                                      = "Manual"
      + user_data                                         = "aG9zdG5hbWU9aXNlcGFuc2VydmVyCnByaW1hcnluYW1lc2VydmVyPTE2OC42My4xMjkuMTYKZG5zZG9tYWluPWV4YW1wbGUuY29tCm50cHNlcnZlcj10aW1lLmdvb2dsZS5jb20KdGltZXpvbmU9VVRDCnBhc3N3b3JkPUMhc2MwSW5kMUAKZXJzYXBpPXllcwpvcGVuYXBpPXllcwpweEdyaWQ9eWVzCnB4Z3JpZF9jbG91ZD15ZXM="
      + zone_balance                                      = true
      + zones                                             = [
          + "1",
          + "2",
          + "3",
        ]

      + admin_ssh_key {
          + public_key = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC70499pJB09BIIXpR6bSwgsR6nMdjJ72FbqwoF2dLhYtVJUQsYbmj1ouo1XynjE1rPbiCtVcO1lKKm4ErbyoVARr6QU38X0WKT9mvMJzPgTmca3BIAp/U0CZHOst7rux2i10nOAs4bBi8YpoTqsPLZSeTqumWvWcx+HVEq11PxAhCoWWMeW5/I1AoM1b1Jiho69n+bgdei+SjlJJ4sVAgayoARjgtayEFSOY6qAdHl1g23Fhy//kLIe0BCBGXcDZ8zlG+C+KKnqokDBnRrm4yOyQaCtRdNJPXpNqhecAAD0X6yZdLjOxfohI+r2zlxzRAXl96ppv975S4z7yit/vBPojTYbTHWLJVWof2N2vrqgcm/DSVWxh1cwUv38PNUuWCVpH4q8fKhZRKezM5ULBESnB5vVS7Z5DzMr7CkwrQkDD4VlsUWFQOlNuXMCT4GSPZPcE9XnzzkrMMnc8D4tfdUEGytnd/EE2f374uMjZ5tCxQfyFxreoEBw6AX3DSlWRKJmav9eMCqYBwJQB9pCU8q+LkRy8GIFwPkQq449BsObroDX4zItt3NvFtVODPUt+iBxzmNj4NJxbgA6SfO55BTvd26CANqSCgaTCvdSdOJj/OOX68sNHhcP6cuXNmX7nqcM/Xd9qCw3PB4IhQP5bQhCSN9r9jY9mZbOKcp9V3+Qw== iseadmin@myserver
            EOT
          + username   = "iseadmin"
        }

      + automatic_instance_repair {
          + enabled      = true
          + grace_period = "PT30M"
        }

      + network_interface {
          + enable_accelerated_networking = false
          + enable_ip_forwarding          = false
          + name                          = "ise-vm-nic"
          + primary                       = true

          + ip_configuration {
              + load_balancer_backend_address_pool_ids = (known after apply)
              + name                                   = "internal"
              + primary                                = true
              + subnet_id                              = "/subscriptions/4af28428-fadd-42d1-ba1c-ba3eef6d4a6c/resourceGroups/ise_dev/providers/Microsoft.Network/virtualNetworks/esc_VNet/subnets/Peter2_subnet"
              + version                                = "IPv4"
            }
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + storage_account_type      = "Premium_LRS"
          + write_accelerator_enabled = false
        }

      + plan {
          + name      = "cisco-ise_3_2"
          + product   = "cisco-ise-virtual"
          + publisher = "cisco"
        }

      + source_image_reference {
          + offer     = "cisco-ise-virtual"
          + publisher = "cisco"
          + sku       = "cisco-ise_3_2"
          + version   = "3.2.543"
        }
    }

  # azurerm_marketplace_agreement.cisco_ise_marketplace_agrmt will be created
  + resource "azurerm_marketplace_agreement" "cisco_ise_marketplace_agrmt" {
      + id                  = (known after apply)
      + license_text_link   = (known after apply)
      + offer               = "cisco-ise-virtual"
      + plan                = "cisco-ise_3_2"
      + privacy_policy_link = (known after apply)
      + publisher           = "cisco"
    }

  # azurerm_monitor_autoscale_setting.ise_scaling_policy will be created
  + resource "azurerm_monitor_autoscale_setting" "ise_scaling_policy" {
      + enabled             = true
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "ISEAutoscaleSetting"
      + resource_group_name = "ise_dev"
      + target_resource_id  = (known after apply)

      + profile {
          + name = "ISE_scaling"

          + capacity {
              + default = 2
              + maximum = 4
              + minimum = 2
            }
        }
    }

  # azurerm_private_dns_zone.ise_vmss_private_dns_zone will be created
  + resource "azurerm_private_dns_zone" "ise_vmss_private_dns_zone" {
      + id                                                    = (known after apply)
      + max_number_of_record_sets                             = (known after apply)
      + max_number_of_virtual_network_links                   = (known after apply)
      + max_number_of_virtual_network_links_with_registration = (known after apply)
      + name                                                  = "example.com"
      + number_of_record_sets                                 = (known after apply)
      + resource_group_name                                   = "ise_dev"
    }

  # azurerm_private_dns_zone_virtual_network_link.ise_vnet_dns_link will be created
  + resource "azurerm_private_dns_zone_virtual_network_link" "ise_vnet_dns_link" {
      + id                    = (known after apply)
      + name                  = "ise_vnet_dns_link"
      + private_dns_zone_name = "example.com"
      + registration_enabled  = true
      + resource_group_name   = "ise_dev"
      + virtual_network_id    = "/subscriptions/4af28428-fadd-42d1-ba1c-ba3eef6d4a6c/resourceGroups/ise_dev/providers/Microsoft.Network/virtualNetworks/esc_VNet"
    }

Plan: 14 to add, 0 to change, 0 to destroy.

```
