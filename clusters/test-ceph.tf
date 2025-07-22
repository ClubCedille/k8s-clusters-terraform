module "cluster_test_ceph" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 4
  name            = "k8s-test-ceph"
  public_ip       = "142.137.247.76"
  owner_tag       = "CEDILLE"
  environment_tag = "TEST"
  onboard_argocd  = true

  controlplanes = {
    cpu_cores = 4
    disk_size = 40
    memory    = 8192
    nodes     = ["pve03"]
  }
  workers = {
    cpu_cores = 4
    disk_size = 40
    memory    = 8192
    nodes     = ["pve01", "pve02", "pve03"]
  }

}

module "k8s-test-ceph-repo" {
  source = "../modules/repo"
  name = "k8s-test-ceph"
  protected = true
  public = true
}