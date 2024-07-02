##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

# Defaults to external ALB
variable "is_internal" {
  type    = bool
  default = true
}

variable "name_prefix" {
  type    = string
  default = ""
}

variable "ip_address_type" {
  type    = string
  default = "ipv4"
}

variable "delete_protection" {
  type    = bool
  default = true
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "public_ip_ids" {
  type    = list(string)
  default = []
}

variable "private_ip_addresses" {
  type    = list(string)
  default = []
}

variable "listener_config" {
  type    = any
  default = {}
}
