output "vm_ip_address" {
  description = "The IP address of the provisioned VM"
  value       = vsphere_virtual_machine.vm.default_ip_address
}

output "app_url" {
  value = "http://${vsphere_virtual_machine.vm.default_ip_address}:5000"
}

output "ssh_command" {
  value = "ssh root@${vsphere_virtual_machine.vm.default_ip_address}"
}

output "vm_root_password" {
  value     = var.vm_root_password
  sensitive = true
}
