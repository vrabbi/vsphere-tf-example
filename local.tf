locals {
  vsphere_user_split = split("@", var.vsphere_user)
  vsphere_user_name  = local.vsphere_user_split[0]
  vm_root_user_pass = "root:${var.vm_root_password}"
}
