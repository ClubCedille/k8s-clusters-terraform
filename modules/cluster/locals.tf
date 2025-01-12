locals {
  subnet = cidrsubnet("${var.network_config.common_subnet}/${var.network_config.common_cidr}", var.network_config.cluster_cidr - var.network_config.common_cidr, var.cluster_id)
  has_public_ip = var.public_ip != null
  cluster_vlan_id = 1000 + var.cluster_id  
}