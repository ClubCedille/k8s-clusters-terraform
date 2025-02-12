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

variable "TFC_WORKSPACE_SLUG" {
  type = string
}

variable "vault_root_token" {
  type = string
}

variable "vault_address" {
  
}