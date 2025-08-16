module "services-v2" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 9
  name            = "k8s-service-v2"
  public_ip       = "142.137.247.75"
  owner_tag       = "SHARED"
  environment_tag = "PRODUCTION"
  onboard_argocd  = true

  controlplanes = {
    cpu_cores = 4
    disk_size = 40
    memory    = 8192
    nodes     = ["pve03", "pve04", "pve06", "pve07", "pve08"]
  }
  workers = {
    cpu_cores = 8
    disk_size = 250
    memory    = 24576
    nodes     = ["pve01", "pve02", "pve03", "pve04", "pve06", "pve07", "pve08"]
  }

  switch_username = var.switch_username
  switch_password = var.switch_password
  switch_url = var.switch_url
}

module "services-repo-v2" {
  source = "../modules/repo"
  name = "k8s-services-v2"
  protected = true
  public = true
}