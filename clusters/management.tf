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

resource "vault_jwt_auth_backend" "tfc_auth_backend" {
  path = "jwt-tfc"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer = "https://app.terraform.io"
}

resource "vault_jwt_auth_backend_role" "tfc_auth_backend_role" {
  backend = vault_jwt_auth_backend.tfc_auth_backend.path
  role_name = "tfc-role"
  role_type = "jwt"
  token_policies = ["config-admin"]
  user_claim = "sub"
  bound_claims = {
    "terraform_organization_name" = split("/", var.TFC_WORKSPACE_SLUG)[0]
    "terraform_workspace_name" = split("/", var.TFC_WORKSPACE_SLUG)[1]
  }
  token_ttl = 1200
}

resource "vault_mount" "kvv2-shared" {
  path        = "kv-shared"
  type        = "kv-v2"
  options = {
    version = "2"
    type    = "kv-v2"
  }
}

resource "vault_policy" "common" {
  name = "common"
  policy = <<EOF
  # create secrets
  path "${vault_mount.kvv2-shared.path}/data/everyone/*" {
    capabilities = [ "read" ]
  }

  # generate new password from password policy
  path "sys/policies/password/+/generate" {
    capabilities = [ "read" ]
  }
  EOF
}

resource "vault_policy" "config-admin" {
  name = "config-admin"
  policy = <<EOF
  path "sys/*" {
      capabilities =  ["create", "read", "update", "delete", "list", "sudo"]
    }

    path "auth/*" {
      capabilities =  ["create", "read", "update", "delete", "list", "sudo"]
    }

    path "github/*" {
      capabilities =  ["create", "read", "update", "delete", "list", "sudo"]
    }

    path "${vault_mount.kvv2-shared.path}/data" {
      capabilities =  ["create", "read", "update", "delete", "list", "sudo"]
    }
  EOF
}