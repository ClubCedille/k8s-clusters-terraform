resource "random_uuid" "controlplanes_uuids" {
  count = length(var.controlplanes.nodes)
}

resource "random_uuid" "workers_uuids" {
  count = length(var.workers.nodes)
}

resource "proxmox_virtual_environment_vm" "controlplanes" {
  for_each = { for i,node in var.controlplanes.nodes : i => node }
  
  name = "${var.name}-controlplane-${each.key}"
  node_name = each.value

  tags = ["CONTROLPLANE", "TF", var.owner_tag, var.environment_tag, var.name]
  vm_id = var.proxmox_base_id + var.cluster_id * 1000 + parseint(each.key, 10)

  machine = "q35"

  cpu {
    cores = var.controlplanes.cpu_cores
    type = "host"
    numa = false
  }

  memory {
    dedicated = var.controlplanes.memory
    # hugepages = "disable"
  }

  disk {
    size = var.controlplanes.disk_size
    interface = "scsi0"
    datastore_id = var.cephrbd_datastore_id
    file_format = "raw"
  }

  cdrom {
    enabled = true
    file_id = "${var.cephfs_datastore_id}:${var.talos_image_id}"
  }

  agent {
    enabled = true
  }

  // vlan internal
  network_device {
    bridge = var.network_config.interface
    vlan_id = var.network_config.internal_vlan_id
  }

  // vlan cluster
  network_device {
    bridge = var.network_config.interface
    vlan_id = local.cluster_vlan_id
  }

  // vlan internal_services
  network_device {
    bridge = var.network_config.interface
    vlan_id = var.network_config.internal_services_vlan_id
  }

  on_boot = true

  smbios {
    uuid = "${random_uuid.controlplanes_uuids[each.key].result}"
  }
}

resource "proxmox_virtual_environment_vm" "workers" {
  for_each = { for i,node in var.workers.nodes : i => node }
  
  name = "${var.name}-worker-${each.key}"
  node_name = each.value
  vm_id = var.proxmox_base_id + var.cluster_id * 1000 + 10 + parseint(each.key, 10)
  tags = ["WORKER", "TF", var.owner_tag, var.environment_tag, var.name]

  machine = "q35"

  cpu {
    cores = var.workers.cpu_cores
    type = "host"
    numa = false
  }

  memory {
    dedicated = var.workers.memory
    # hugepages = "disable"
  }

  disk {
    size = var.workers.disk_size
    interface = "scsi0"
    datastore_id = var.cephrbd_datastore_id
    file_format = "raw"
  }

  cdrom {
    enabled = true
    file_id = "${var.cephfs_datastore_id}:${var.talos_image_id}"
  }

  agent {
    enabled = true
  }
  

  // vlan internal
  network_device {
    bridge = var.network_config.interface
    vlan_id = var.network_config.internal_vlan_id
  }

  // vlan cluster
  network_device {
    bridge = var.network_config.interface
    vlan_id = local.cluster_vlan_id
  }

  // vlan public
  dynamic "network_device" {
    for_each = var.public_ip != null ? [1] : []
    content {
      bridge = var.network_config.interface
      vlan_id = var.network_config.external_vlan_id
    }
  }

  // vlan internal_services
  network_device {
    bridge = var.network_config.interface
    vlan_id = var.network_config.internal_services_vlan_id
  }

  on_boot = true

  smbios {
    uuid = "${random_uuid.workers_uuids[each.key].result}"
  }
}

