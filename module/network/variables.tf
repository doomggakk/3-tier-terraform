variable "create" {
  description = "Controls if Amore AWS Module resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "project-pre-code" {
  default = "DEV"
}

variable "region" {
  default = "ap-northeast-2"
}


# --------------------------------------------------------------
# VPC
# --------------------------------------------------------------


variable "vpc_cidr" {
  default = "10.106.8.0/21"
}

variable "create_vpc_endpoint" {
  default = false
}


# --------------------------------------------------------------
# Subnet
# --------------------------------------------------------------
variable "create_subnets_pri" {
  description = "Controls if private subnets should be created"
  type        = bool
  default     = false
}

variable "create_subnets_pub" {
  description = "Controls if public subnets should be created"
  type        = bool
  default     = false
}

variable "create_subnets_db" {
  description = "Controls if db subnets should be created"
  type        = bool
  default     = false
}


variable "subnets_pri" {
  default = []
}

variable "subnets_pub" {
  default = []
}

variable "subnets_db" {
  default = []
}



# --------------------------------------------------------------
# Route Table
# --------------------------------------------------------------
variable "create_rtb_pri" {
  description = "Controls if a RTB should be created"
  type        = bool
  default     = false
}

variable "create_rtb_pub" {
  description = "Controls if a RTB should be created"
  type        = bool
  default     = false
}

variable "create_rtb_db" {
  description = "Controls if a RTB should be created"
  type        = bool
  default     = false
}

variable "rtb-pri" {
  default = {}
}

variable "rtb_route_pri" {
  default = []
}

variable "rtb-pub" {
  default = {}
}

variable "rtb_route_pub" {
  default = []
}

variable "rtb-db" {
  default = {}
}

variable "rtb_route_db" {
  default = []
}
