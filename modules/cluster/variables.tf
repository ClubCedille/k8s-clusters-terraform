variable "name" {
  type = string
}

variable "domain" {
  type = string
}

variable "cluster_id" {
  type = number
  validation {
    condition = var.cluster_id >= 1 && var.cluster_id <= 512
    error_message = "must be between 1 and 512"
  }
}

variable "controlplanes" {
  type = object({
    nodes = list(string),
    cpu_cores = number,
    memory = number,
    disk_size = number,
  })

  # validation {
  #    condition = anytrue([
  #       length(var.controlplanes.nodes) == 1,
  #       length(var.controlplanes.nodes) == 3,
  #       length(var.controlplanes.nodes) == 5
  #       ])
  #   error_message = "must have 1, 3 or 5 nodes"
  # }
}

variable "workers" {
  type = object({
    nodes = list(string),
    cpu_cores = number,
    memory = number,
    disk_size = number,
  })
}

variable "network_config" {
  type = object({
    interface = string,
    internal_vlan_id = number,
    external_vlan_id = number,  
    internal_services_vlan_id = number,
    common_subnet = string,
    internal_services_subnet = string,
    common_cidr = number,
    cluster_cidr = number,
  }) 
}

variable "public_ip" {
  nullable = true
}

variable "proxmox_base_id" {
    type = number
}

variable "talos_image_id" { // "iso/metal-amd64-omni-cedille-v1.7.6.iso"
  type = string
}

variable "cephfs_datastore_id" { //Ceph_Common
  type = string
}

variable "cephrbd_datastore_id" { //Ceph_Common
  type = string
}

variable "talos_version" {
  type = string
}

variable "k8s_version" {
  type = string
  
}

variable "owner_tag" {
  type = string
}

variable "environment_tag" {
  type = string
}

variable "omni_url" {
  type = string
  default = "https://cedille.kubernetes.omni.siderolabs.io"
}

variable "onboard_argocd" {
  type = bool
  default = true
}