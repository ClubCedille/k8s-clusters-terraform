terraform {
  required_version = ">= 0.12"

  required_providers {
    restapi = {
      source = "Mastercard/restapi"
      version = "2.0.1"
    }
  }
}

provider "restapi" {
  alias = "switch"
  uri                  = var.switch_url
  username             = var.switch_username
  password             = var.switch_password
  insecure             = true
  headers = {
    "Content-Type" = "application/json"
  }
}