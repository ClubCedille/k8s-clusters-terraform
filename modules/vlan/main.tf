resource "terraform_data" "vlan_id" {
  input = var.vlan_id
}

resource "restapi_object" "vlan" {
  provider = restapi.switch
  path = "/ins"
  create_method = "POST"
  read_method = "POST"
  update_method = "POST"
  destroy_method = "POST"

  create_path = "/ins"
  read_path = "/ins"
  update_path = "/ins"
  destroy_path = "/ins"

  object_id = "vlan_id:${var.vlan_id};vlan_name:${var.vlan_name}"

  data = jsonencode({
    ins_api = {
      version = "1.0"
      type = "cli_conf"
      chunk = "0"
      sid = "1"
      input = "vlan ${var.vlan_id} ;name ${var.vlan_name} ;exit ;copy r s" 
      output_format = "json"
    }
  })

  read_data = jsonencode({
    ins_api = {
      version = "1.0"
      type = "cli_show"
      chunk = "0"
      sid = "1"
      input = "show vlan id ${var.vlan_id}"
      output_format = "json"
    }
  })

  destroy_data = jsonencode({
    ins_api = {
      version = "1.0"
      type = "cli_conf"
      chunk = "0"
      sid = "1"
      input = "vlan ${var.vlan_id} ;no vlan ${var.vlan_id} ;exit ;copy r s"
      output_format = "json"
    }
  })

  lifecycle {
    ignore_changes = [ data ]
    replace_triggered_by = [ terraform_data.vlan_id ] 
  }
}

