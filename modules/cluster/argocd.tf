data "external" "cluster_token" {
  depends_on = [ terraform_data.cluster ]
  program = ["bash", "-c", "./omnictl kubeconfig --cluster ${var.name} --service-account --user external_token --force tmp-${var.name}-kubeconfig && cat tmp-${var.name}-kubeconfig | yq -j -c '.users[0].user'"]
}

resource "argocd_project" "project" {
  for_each = toset(var.onboard_argocd ? ["true"] : []) 
  depends_on = [ argocd_cluster.talos ]
  metadata {
    name      = var.name
    namespace = "argocd"
  }

  spec {
    description = "cluster project"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "${var.omni_url}?cluster=${var.name}"
      namespace = "*"
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "argocd_cluster" "talos" {
  for_each = toset(var.onboard_argocd ? ["true"] : []) 
  server = "${var.omni_url}?cluster=${var.name}"
  name   = var.name

  config {
    bearer_token = data.external.cluster_token.result["token"]
  }

  metadata {
      labels = {
        "etsmtl.club/external-network" = "true"
        "etsmtl.club/internal-network" = "true"
      }
      annotations = {
        "etsmtl.club/external-ip" = "${var.public_ip}"
        "etsmtl.club/internal-ip" = "${cidrhost(var.network_config.internal_services_subnet, 1 + var.cluster_id)}"
      }
    }
}