module "test-net-2" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 2
  name            = "k8s-test-net-2"
  public_ip       = "142.137.247.89"
  owner_tag       = "SHARED"
  environment_tag = "TESTING"
  onboard_argocd  = false

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