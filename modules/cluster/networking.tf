module "vlan" {
  source = "../vlan"
  vlan_id = 1000 + var.cluster_id
  vlan_name = "k8s_${var.cluster_id}"
  switch_url = var.switch_url
  switch_username = var.switch_username
  switch_password = var.switch_password
}