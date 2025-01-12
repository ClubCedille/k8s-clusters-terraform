module "test_letsgo" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 2
  name            = "k8s-test-letsgo"
  public_ip       = "142.137.247.89"
  owner_tag       = "CEDILLE"
  environment_tag = "TESTING"
  onboard_argocd  = true

  controlplanes = {
    cpu_cores = 4
    disk_size = 40
    memory    = 4096
    nodes     = ["pve04"]
  }
  workers = {
    cpu_cores = 8
    disk_size = 100
    memory    = 16384
    nodes     = ["pve06", "pve07", "pve08"]
  }

}
