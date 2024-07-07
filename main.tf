resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
  lower   = false
  numeric = true
}

resource "vsphere_virtual_machine" "vm" {
  name             = "${local.vsphere_user_name}-example-vm-${random_string.random.result}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.cpu
  memory           = var.memory_mb
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  folder           = var.folder
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name   = "${local.vsphere_user_name}-example-vm-${random_string.random.result}"
        domain      = var.domain
        script_text = "echo ${local.vm_root_user_pass} | sudo chpasswd && sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config"
      }
      network_interface {}
    }
  }
}
resource "time_sleep" "wait_60_seconds" {
  depends_on = [vsphere_virtual_machine.vm]

  create_duration = "60s"
}
resource "ssh_resource" "init" {
  depends_on = [time_sleep.wait_60_seconds]
  when        = "create"
  host        = vsphere_virtual_machine.vm.default_ip_address
  agent       = false
  user        = "root"
  password    = var.vm_root_password
  timeout     = "2m"
  retry_delay = "5s"

  file {
    content     = <<EOF
git clone https://github.com/vrabbi/python-demo-app
cd python-demo-app/
apt install python3-pip -y
pip3 install -r requirements.txt
export FLASK_APP=server.py
flask run --host 0.0.0.0 &
exit 0
EOF
    destination = "/root/app-deploy.sh"
    permissions = "0700"
  }

  commands = [
    "/root/app-deploy.sh"
  ]
}
