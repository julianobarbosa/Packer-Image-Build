output "vm_id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.azxdev01.id
}

output "vm_name" {
  description = "Name of the Virtual Machine in S.O."
  value       = azurerm_linux_virtual_machine.azxdev01.computer_name
}

output "computer_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.azxdev01.name
}

output "vm_hostname" {
  description = "Hostname of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.azxdev01.computer_name
}

# output "vm_public_ip_address" {
#   description = "Public IP address of the Virtual Machine"
#   value       = one(azurerm_public_ip.public_ip[*].ip_address)
# }

# output "vm_public_ip_id" {
#   description = "Public IP ID of the Virtual Machine"
#   value       = one(azurerm_public_ip.public_ip[*].id)
# }

# output "vm_public_domain_name_label" {
#   description = "Public DNS of the Virtual machine"
#   value       = one(azurerm_public_ip.public_ip[*].domain_name_label)
# }

output "vm_private_ip_address" {
  description = "Private IP address of the Virtual Machine"
  value       = azurerm_network_interface.azxdev01-private-nic.private_ip_address
}

output "vm_nic_name" {
  description = "Name of the Network Interface Configuration attached to the Virtual Machine"
  value       = azurerm_network_interface.azxdev01-private-nic.name
}

output "vm_nic_id" {
  description = "ID of the Network Interface Configuration attached to the Virtual Machine"
  value       = azurerm_network_interface.azxdev01-private-nic.id
}

# output "vm_nic_ip_configuration_name" {
#   description = "Name of the IP Configuration for the Network Interface Configuration attached to the Virtual Machine"
#   value       = local.ip_configuration_name
# }

output "vm_identity" {
  description = "Identity block with principal ID"
  value       = azurerm_linux_virtual_machine.azxdev01.identity
}

output "vm_admin_username" {
  description = "Virtual Machine admin username"
  value       = var.admin_username
  sensitive   = true
}

output "vm_admin_password" {
  description = "Virtual Machine admin password"
  value       = var.admin_password
  sensitive   = true
}

# output "maintenance_configurations_assignments" {
#   description = "Maintenance configurations assignments configurations."
#   value       = azurerm_maintenance_assignment_virtual_machine.maintenance_configurations
# }

# output "availability_set_id" {
#   description = "id of the availability set where the vms are provisioned."
#   value       = "${azurerm_availability_set.vm.id}"
# }
