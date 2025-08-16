
module "cluster_management_v2" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 8
  name            = "k8s-management-v2"
  public_ip       = "142.137.247.74"
  owner_tag       = "COMMUN"
  environment_tag = "MANAGEMENT"
  onboard_argocd  =  false

  controlplanes = {
    cpu_cores = 4
    disk_size = 40
    memory    = 4096
    nodes     = ["pve01", "pve02", "pve03", "pve04", "pve06"]
  }
  workers = {
    cpu_cores = 12
    disk_size = 100
    memory    = 16384
    nodes     = ["pve01", "pve02", "pve03", "pve04", "pve06", "pve07", "pve08"]
  }

  switch_username = var.switch_username
  switch_password = var.switch_password
  switch_url = var.switch_url
}

module "k8s-management-v2-repo" {
  source = "../modules/repo"
  name = "k8s-management-v2"
  protected = false
  public = true
}