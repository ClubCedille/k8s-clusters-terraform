module "cedille-production-v2" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 10
  name            = "k8s-cedille-production-v2"
  public_ip       = "142.137.247.79"
  owner_tag       = "CEDILLE"
  environment_tag = "PRODUCTION"
  onboard_argocd  = true

  controlplanes = {
    cpu_cores = 6
    disk_size = 40
    memory    = 10240
    nodes     = ["pve03", "pve04", "pve06", "pve07", "pve08"]
  }
  workers = {
    cpu_cores = 10
    disk_size = 250
    memory    = 31949
    nodes     = ["pve01", "pve02", "pve03", "pve04", "pve06", "pve07", "pve08"]
  }

  switch_username = var.switch_username
  switch_password = var.switch_password
  switch_url = var.switch_url

}

module "cedille-prod-v2-repo" {
  source = "../modules/repo"
  name = "k8s-cedille-production-v2"
  protected = false
  public = true
}
