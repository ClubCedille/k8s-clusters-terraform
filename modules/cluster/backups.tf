locals {
  create_backups = var.b2_application_key != null && var.b2_application_key_id != null
}

resource "b2_bucket" "backup_bucket" {
  count = local.create_backups ? 1 : 0
  
  bucket_name = var.bucket_name
  bucket_type = var.bucket_type

  dynamic "lifecycle_rules" {
    for_each = var.lifecycle_rules
    content {
      days_from_hiding_to_deleting  = lifecycle_rules.value.days_from_hiding_to_deleting
      days_from_uploading_to_hiding = lifecycle_rules.value.days_from_uploading_to_hiding
      file_name_prefix              = lifecycle_rules.value.file_name_prefix
    }
  }
}

resource "b2_application_key" "backup_key" {
  count = local.create_backups ? 1 : 0
  
  key_name  = var.application_key_name
  capabilities = var.application_key_capabilities
  bucket_id = b2_bucket.backup_bucket[0].id
}

output "b2_application_key_id" {
  value = local.create_backups ? b2_application_key.backup_key[0].id : ""
}

output "b2_application_key" {
  value = local.create_backups ? b2_application_key.backup_key[0].key : ""
}

output "backup_enabled" {
  value = local.create_backups
}
