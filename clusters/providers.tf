terraform {
  required_version = ">= 1.6.0"
  cloud { 
    
    organization = "cedille" 

    workspaces { 
      name = "k8s-clusters" 
    } 
  } 

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
      version = "0.70.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.1.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "~> 4.6.0"
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

provider "vault" {
  token = var.vault_root_token
  address = var.vault_address
}