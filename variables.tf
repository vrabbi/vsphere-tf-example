variable "vsphere_user" {
}
variable "vsphere_password" {
  sensitive = true
}
variable "vsphere_server" {
}
variable "memory_mb" {
  default = 8192
}
variable "cpu" {
  default = 4
}

variable "folder" {
  default = "/LABS/Lev"
}
variable "domain" {
  default = "terasky.local"
}
variable "datastore" {
  default = "LAB-V3-vSANDatastore"
}
variable "datacenter" {
  default = "Main"
}
variable "cluster" {
  default = "LAB-V3"
}
variable "network" {
  default = "lev-dhcp-network"
}
variable "template" {
  default = "linux-onboarding"
}

variable "vm_root_password" {
}
