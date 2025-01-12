provider "github" {
  owner = "ClubCedille"
  app_auth {
    id = "673366"
    installation_id = "44748310"
    pem_file = file("~/Downloads/cedille-terraform-cloud.2024-12-23.private-key.pem")
  }
}

resource "github_repository" "repo" {
    name        = var.name
    description = "Cluster Kubernetes: ${var.name}"
    visibility = var.public ? "public" : "private"
    template {
      owner = "ClubCedille"
      repository = "k8s-template"
    }
}

resource "github_repository_collaborators" "repo_permissions" {
  depends_on = [ github_repository.repo ]

  repository = github_repository.repo.name

  team {
    permission = "admin"
    team_id = "exec"
  }

  team {
    permission = "maintain"
    team_id = "sre"
  }

  team {
    permission = "push"
    team_id = "members"
  }
  
}

resource "github_branch_protection" "repo_protection" {
  depends_on = [ github_repository.repo ]
  count = var.protected ? 1 : 0

  repository_id = github_repository.repo.name

  pattern          = "main"
  enforce_admins   = false
  allows_deletions = false
  allows_force_pushes = false
  required_linear_history = true

  required_pull_request_reviews {
    dismiss_stale_reviews  = true
    require_last_push_approval = true
    required_approving_review_count = 1
  }

  required_status_checks {
    strict = true
    contexts = [ 
      "ci/kubernetes-repo-standard/kubescore-check/kube-score",
      "ci/kubernetes-repo-standard/yaml-check/yaml-lint-check",
      "ci/kubernetes-repo-standard/terraform-check/terraform-lint",
    ]
  }
}

