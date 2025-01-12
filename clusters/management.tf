module "cluster_management" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 1
  name            = "k8s-management"
  public_ip       = "142.137.247.86"
  owner_tag       = "COMMUN"
  environment_tag = "MANAGEMENT"
  onboard_argocd  = false

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

}
