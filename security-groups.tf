##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

# Security groups for ALB
resource "aws_security_group" "this" {
  name        = "nlb-${local.system_name}-sg"
  description = "Network Load Balancer security group for ${local.system_name}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.all_tags,
    {
      Name = "nlb-${local.system_name}-sg"
    }
  )

  lifecycle {
    ignore_changes = [
      ingress,
      egress
    ]
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_egress_rule" "sg_all" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "-1"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic by default"
  tags              = local.all_tags
}

resource "aws_vpc_security_group_ingress_rule" "listener" {
  for_each          = var.listener_config
  security_group_id = aws_security_group.this.id
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.allowed_cidr
  description       = "Allow all inbound traffic on port ${each.value.port}"
  tags              = local.all_tags
}
