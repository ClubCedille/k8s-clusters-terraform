variable "vlan_id" {
  type = number
  validation {
    condition     = var.vlan_id >= 1 && var.vlan_id <= 4094
    error_message = "The VLAN ID must be between 1 and 4094."
  }
}

variable "vlan_name" {
  type = string
}

variable "switch_url" {
  type = string
}

variable "switch_username" {
    type = string
}

variable "switch_password" {
   type = string
   sensitive = true
}