##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# Defaults to external ALB
variable "is_internal" {
  description = "Set to true for an internal Network Load Balancer, false for an external one"
  type        = bool
  default     = true
  nullable    = false
}

variable "name_prefix" {
  description = "Prefix for the Network Load Balancer name"
  type        = string
  default     = ""
}

variable "ip_address_type" {
  description = "IP address type for the Network Load Balancer, either 'ipv4' or 'dualstack'"
  type        = string
  default     = "ipv4"
  nullable    = false
}

variable "delete_protection" {
  description = "Enable deletion protection for the Network Load Balancer"
  type        = bool
  default     = true
  nullable    = false
}

variable "vpc_id" {
  description = "VPC ID where the Network Load Balancer will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the Network Load Balancer, optional if using public subnets"
  type        = list(string)
  default     = []
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the Network Load Balancer, optional if using private subnets"
  type        = list(string)
  default     = []
}

variable "public_ip_ids" {
  description = "(optional) List of public IP allocation IDs for the Network Load Balancer in public subnets"
  type        = list(string)
  default     = []
}

variable "private_ip_addresses" {
  description = "(optional) List of private IP addresses for the Network Load Balancer in private subnets"
  type        = list(string)
  default     = []
}

## YAML configuration for listeners
#listener_config:
#  - port: 80
#    protocol: TCP
#    certificate_arn: "arn:aws:acm:region:account-id:certificate/certificate-id" # (optional) required for SSL listeners
#    alpn_policy: "HTTP1Only" # (optional) defaults to null
#    target_group_arn: "arn:aws:elasticloadbalancing:region:account-id:targetgroup/target-group-name/target-group-id"
variable "listener_config" {
  description = "Configuration for listeners on the Network Load Balancer"
  type        = any
  default     = {}
  nullable    = false
}

variable "enable_cross_zone" {
  description = "(optional) Enable cross-zone load balancing for the Network Load Balancer"
  type        = bool
  default     = false
  nullable    = false
}