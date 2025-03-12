module "test" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 6
  name            = "k8s-test"
  public_ip       = "142.137.247.88"
  owner_tag       = "SHARED"
  environment_tag = "PRODUCTION"
  onboard_argocd  = true

  controlplanes = {
    cpu_cores = 4
    disk_size = 40
    memory    = 8192
    nodes     = ["pve03", "pve04", "pve06"]
  }
  workers = {
    cpu_cores = 4
    disk_size = 60
    memory    = 8192
    nodes     = ["pve01", "pve02", "pve03"]
  }

}