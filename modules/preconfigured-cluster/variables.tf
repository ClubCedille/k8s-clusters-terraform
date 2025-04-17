variable "name" {
  type = string
  
}

variable "cluster_id" {
  type = number
  
  validation {
    condition = var.cluster_id >= 1 && var.cluster_id <= 512
    error_message = "must be between 1 and 512"
  }
}

variable "controlplanes" {
  type = object({
    nodes = list(string),
    cpu_cores = number,
    memory = number,
    disk_size = number,
  })

  # validation {
  #    condition = anytrue([
  #       length(var.controlplanes.nodes) == 1,
  #       length(var.controlplanes.nodes) == 3,
  #       length(var.controlplanes.nodes) == 5
  #       ])
  #   error_message = "must have 1, 3 or 5 nodes"
  # }
}

variable "workers" {
  type = object({
    nodes = list(string),
    cpu_cores = number,
    memory = number,
    disk_size = number,
  })
}

variable "public_ip" {
  nullable = true
  description = "IP publique. Mettre null pour ne pas mettre une IP publique. Les IPs doivent etre entre  142.137.247.71-142.137.247.89. .85-.89 sont réservés aux services SHARED"

  validation {
    condition = var.public_ip == null || can(regex("142\\.137\\.247\\.(7[1-9]|8[0-9])", var.public_ip)) 
    error_message = "must be between 142.137.247.71 and 142.137.247.89"
  }
}

variable "owner_tag" {
  type = string
}

variable "environment_tag" {
  type = string
}

variable "onboard_argocd" {
  type = bool
  default = true
}

variable "b2_application_key_id" {
  type = string
  default = null
}

variable "b2_application_key" {
  type = string
  default = null
}

variable "lifecycle_rules" {
  type = list(object({
    days_from_hiding_to_deleting = optional(number)
    days_from_uploading_to_hiding = optional(number)
    file_name_prefix = optional(string)
  }))
  default = []
}