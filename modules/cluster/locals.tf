locals {
  has_public_ip = var.public_ip != null
  cluster_vlan_id = 1000 + var.cluster_id
}