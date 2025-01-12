resource "null_resource" "always_run" {
  triggers = {
    "always_run" = "${timestamp()}"
  }
}

resource "terraform_data" "controlplanes_machine_configs" {
  depends_on = [proxmox_virtual_environment_vm.controlplanes]
  for_each   = { for i, node in var.controlplanes.nodes : i => node }

  input = {
    "ROLE"                  = "controlplane"
    "UUID"                  = random_uuid.controlplanes_uuids[each.key].result
    "NETWORK_CONFIG_SUBNET" = local.subnet
    "IP"                    = "${cidrhost(local.subnet, 5 + parseint(each.key, 10))}/${var.network_config.cluster_cidr}"
    "GATEWAY"               = "${cidrhost(local.subnet, 1)}"
    "NAME"                  = var.name
    "DOMAIN"                = var.domain
    "KEY"                   = each.key,
    "HAS_PUBLIC_IP"         = "false"
    "CLUSTER_INTERFACE_MAC" = [for dev in proxmox_virtual_environment_vm.controlplanes[each.key].network_device
    : lower(dev.mac_address) if dev.vlan_id == local.cluster_vlan_id][0]
    "INTERNAL_INTERFACE_MAC" = [for dev in proxmox_virtual_environment_vm.controlplanes[each.key].network_device
    : lower(dev.mac_address) if dev.vlan_id == var.network_config.internal_vlan_id][0]
  }

  provisioner "local-exec" {
    when        = create
    environment = self.input
    command     = "envsubst < ${path.module}/machineconfig.template.yaml | cat; envsubst < ${path.module}/machineconfig.template.yaml | ./omnictl apply -f /dev/stdin"
  }

  provisioner "local-exec" {
    when        = destroy
    environment = self.output
    command     = "./omnictl delete ConfigPatches 600-$UUID; ./omnictl delete MachineLabels $UUID"
  }

  lifecycle {
    //replace_triggered_by = [null_resource.always_run]
  }

}

resource "terraform_data" "workers_machine_configs" {
  depends_on = [proxmox_virtual_environment_vm.workers]
  for_each   = { for i, node in var.workers.nodes : i => node }

  input = {
    "ROLE"                  = "worker"
    "UUID"                  = random_uuid.workers_uuids[each.key].result
    "NETWORK_CONFIG_SUBNET" = local.subnet
    "IP"                    = "${cidrhost(local.subnet, 15 + parseint(each.key, 10))}/${var.network_config.cluster_cidr}"
    "GATEWAY"               = "${cidrhost(local.subnet, 1)}"
    "NAME"                  = var.name
    "DOMAIN"                = var.domain
    "KEY"                   = each.key,
    "HAS_PUBLIC_IP"         = var.public_ip != null ? "true" : "false"
    "CLUSTER_INTERFACE_MAC" = [for dev in proxmox_virtual_environment_vm.workers[each.key].network_device
    : lower(dev.mac_address) if dev.vlan_id == local.cluster_vlan_id][0]
    "EXTERNAL_INTERFACE_MAC" = [for dev in proxmox_virtual_environment_vm.workers[each.key].network_device
    : lower(dev.mac_address) if dev.vlan_id == var.network_config.external_vlan_id][0]
    "INTERNAL_INTERFACE_MAC" = [for dev in proxmox_virtual_environment_vm.workers[each.key].network_device
    : lower(dev.mac_address) if dev.vlan_id == var.network_config.internal_vlan_id][0]
  }

  provisioner "local-exec" {
    when        = create
    environment = self.input
    command     = "envsubst < ${local.has_public_ip ? "${path.module}/machineconfig-publicip.template.yaml" : "${path.module}/machineconfig.template.yaml"} | ./omnictl apply -f /dev/stdin"
  }

  provisioner "local-exec" {
    when        = destroy
    environment = self.output
    command     = "./omnictl delete ConfigPatches 600-$UUID; ./omnictl delete MachineLabels $UUID"
  }

  lifecycle {
    //replace_triggered_by = [null_resource.always_run]
  }
}

resource "terraform_data" "machine_classes" {

  input = var.name

  provisioner "local-exec" {
    when = create
    environment = {
      "NAME" = var.name
    }
    command = "envsubst < ${path.module}/machineclasses.template.yaml | cat; envsubst < ${path.module}/machineclasses.template.yaml | ./omnictl apply -f /dev/stdin"
  }

  provisioner "local-exec" {
    when = destroy
    environment = {
      "NAME" = self.output
    }
    command = "./omnictl delete machineclass $NAME-controlplane; ./omnictl delete machineclass $NAME-worker"
  }
}

resource "terraform_data" "cluster" {

  depends_on = [proxmox_virtual_environment_vm.controlplanes, proxmox_virtual_environment_vm.workers, terraform_data.machine_classes, terraform_data.controlplanes_machine_configs, terraform_data.workers_machine_configs]
  input = {
    "NAME"          = var.name
    "K8S_VERSION"   = var.k8s_version
    "TALOS_VERSION" = var.talos_version
  }

  provisioner "local-exec" {
    when        = create
    environment = self.input
    command     = "envsubst < ${path.module}/cluster.template.yaml | ./omnictl cluster template sync -f /dev/stdin" //; envsubst < ${path.module}/cluster.template.yaml | ./omnictl cluster template status --file /dev/stdin"
  }

  provisioner "local-exec" {
    when        = destroy
    environment = self.output
    command     = "envsubst < ${path.module}/cluster.template.yaml | ./omnictl cluster template delete -v --destroy-disconnected-machines -f /dev/stdin"
  }
}
