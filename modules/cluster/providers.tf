terraform {
  required_version = ">= 0.12"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    tfe = {
      version = "~> 0.50.0"
    }
    proxmox = {
      source = "bpg/proxmox"
      version = ">= 0.70.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.1.0"
    }
  }
}