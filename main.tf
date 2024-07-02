##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  optionq = var.is_internal ? "i" : "e"
  lb_name = var.name_prefix != "" ? format("nlb-%s-%s-%s", local.optionq, var.name_prefix, local.system_name) : format("nlb-%s-%s", local.optionq, local.system_name)
  local_mappings = [
    for item in range(0, length(var.private_subnet_ids) - 1) : {
      subnet_id    = var.private_subnet_ids[item]
      ipv4_address = var.private_ip_addresses[item]
    }
  ]
  public_mappings = [
    for item in range(0, length(var.public_subnet_ids) - 1) : {
      subnet_id     = var.public_subnet_ids[item]
      allocation_id = var.public_ip_ids[item]
    }
  ]
  address_mappings = coalescelist(concat(local.public_mappings, local.local_mappings))
}

resource "aws_lb" "this" {
  name                       = local.lb_name
  internal                   = var.is_internal
  load_balancer_type         = "network"
  security_groups            = [aws_security_group.this.id]
  subnets                    = var.is_internal ? var.private_subnet_ids : var.public_subnet_ids
  ip_address_type            = var.ip_address_type
  enable_deletion_protection = var.delete_protection

  dynamic "subnet_mapping" {
    for_each = local.address_mappings
    content {
      subnet_id            = subnet_mapping.value.subnet_id
      allocation_id        = try(subnet_mapping.value.allocation_id, null)
      private_ipv4_address = try(subnet_mapping.value.ipv4_address, null)
    }
  }

  tags = merge(
    local.all_tags,
    {
      Name = local.lb_name
    }
  )
  lifecycle {
    ignore_changes = [
      security_groups,
    ]
  }
}

# Listeners
resource "aws_lb_listener" "listener" {
  for_each          = var.listener_config
  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  certificate_arn   = each.value.certificate_arn
  alpn_policy       = each.value.alpn_policy

  default_action {
    type             = "forward"
    target_group_arn = each.value.target_group_arn
  }
  tags = merge(
    local.all_tags,
    {
      Name = format("nlb-%s-%s", each.key, local.system_name)
    }
  )
}
