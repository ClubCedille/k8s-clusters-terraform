resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = var.name
}

resource "vault_kubernetes_auth_backend_config" "kubernetes_auth_backend" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = "${var.omni_url}"
  token_reviewer_jwt     = data.external.cluster_token.result["token"]
  disable_iss_validation = true
  disable_local_ca_jwt   = true
}

resource "vault_mount" "kvv2-kubernetes" {
  path        = "kv-${var.name}"
  type        = "kv-v2"
  options = {
    version = "2"
    type    = "kv-v2"
  }
}

resource "vault_policy" "kubernetes_reader_policy" {
  name = "${var.name}-reader"
  policy = <<EOF
  path "${vault_mount.kvv2-kubernetes.path}/data/{{identity.entity.aliases.$${auth/kubernetes/@accessor}.metadata.service_account_namespace}}/{{identity.entity.aliases.$${auth/kubernetes/@accessor}.metadata.service_account_name}}/*" {
      capabilities = [ "read" ]
  }
  EOF
}

resource "vault_policy" "kubernetes_writer_policy" {
  name = "${var.name}-writer"
  policy = <<EOF
  path "${vault_mount.kvv2-kubernetes.path}/data/{{identity.entity.aliases.$${auth/kubernetes/@accessor}.metadata.service_account_namespace}}/{{identity.entity.aliases.$${auth/kubernetes/@accessor}.metadata.service_account_name}}/*" {
      capabilities = [ "create", "update", "delete" ]
  }
  EOF
}

resource "vault_kubernetes_auth_backend_role" "kubernetes_auth_backend_role" {
  backend               = vault_kubernetes_auth_backend_config.kubernetes_auth_backend.backend
  role_name             = "${var.name}-reader"
  bound_service_account_names = ["*"]
  bound_service_account_namespaces = ["*"]
  token_policies        = [vault_policy.kubernetes_reader_policy.name]
}

resource "vault_kubernetes_auth_backend_role" "kubernetes_auth_backend_role_writer" {
    backend               = vault_kubernetes_auth_backend_config.kubernetes_auth_backend.backend
    role_name             = "${var.name}-writer"
    bound_service_account_names = ["*"]
    bound_service_account_namespaces = ["*"]
    token_policies        = [vault_policy.kubernetes_writer_policy.name]
}