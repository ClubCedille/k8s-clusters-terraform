terraform {
  required_version = ">= 1.6.0"

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
      source  = "bpg/proxmox"
      version = "0.66.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.1.0"
    }
  }
}

provider "proxmox" {
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  
  endpoint      = var.proxmox_endpoint
  insecure      = true
  random_vm_ids = true

}

provider "argocd" {
  server_addr = var.argocd_addr

  username = "admin"
  password = var.argocd_admin_password
}

provider "github" {
  owner = var.github_owner
  app_auth {
    id = var.github_app_id
    installation_id = var.github_installation_id
    pem_file = var.github_pem_file
  }
}

variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "argocd_addr" {
  type = string
}

variable "argocd_admin_password" {
  type = string
  sensitive = true
}

variable "github_owner" {
  type = string
}

variable "github_app_id" {
  type = string
}

variable "github_installation_id" {
  type = string
}

variable "github_pem_file" {
  type = string
  sensitive = true
}

module "test_etcd" {
  source = "../modules/preconfigured-cluster"

  cluster_id      = 4
  name            = "k8s-test-etcd"
  public_ip       = null
  owner_tag       = "CEDILLE"
  environment_tag = "TESTING"
  onboard_argocd  = false

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
    nodes     = []
  }

}
