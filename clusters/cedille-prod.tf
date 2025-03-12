module "cedille-production" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 5
  name            = "k8s-cedille-production"
  public_ip       = "142.137.247.73"
  owner_tag       = "CEDILLE"
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

}

module "cedille-prod-repo" {
  source = "../modules/repo"
  name = "k8s-cedille-prod"
  protected = false
  public = true
}