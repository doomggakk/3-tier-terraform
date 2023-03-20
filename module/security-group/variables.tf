variable "name" {
  default = ""
}

variable "description" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "tags" {
  default = {}
}


variable "security_group_rules" {
  default = {}
}

variable "default_tags" {
  default = {Managed = "Terraform"}
}


