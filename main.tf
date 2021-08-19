resource "aws_security_group" "msk" {
  name   = var.cluster_name
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.security_group_tags, { Name=var.cluster_name })
}

resource "aws_security_group_rule" "msk_cidr_block_rules" {
  for_each          = { for rule in var.msk_security_group_rules: rule.description => rule if rule.source_security_group_id == "" || !rule.self && length(rule.cidr_blocks) > 0 }
  security_group_id = aws_security_group.msk.id
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = each.value.type
}

resource "aws_security_group_rule" "msk_source_security_group_id_rules" {
  for_each                 = { for rule in var.msk_security_group_rules: rule => rule if length(rule.cidr_blocks) == 0 || !rule.self && rule.source_security_group_id != "" }
  security_group_id        = aws_security_group.msk.id
  source_security_group_id = each.value.source_security_group_id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  type                     = each.value.type
}

resource "aws_security_group_rule" "msk_self_rules" {
  for_each          = { for rule in var.msk_security_group_rules: rule => rule if length(rule.cidr_blocks) == 0 || rule.source_security_group_id == "" && rule.self }
  security_group_id = aws_security_group.msk.id
  self              = each.value.self
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = each.value.type
}

resource "aws_msk_cluster" "msk" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_broker_nodes

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    ebs_volume_size = var.broker_ebs_volume_size
    client_subnets  = var.subnets
    security_groups = [aws_security_group.msk.id]
    az_distribution = "DEFAULT"
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  tags = merge(var.msk_tags, { Name=var.cluster_name })
}