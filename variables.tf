variable "cluster_name" {
  description = "MSK Cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "kafka_version" {
  description = "VPC ID"
  type        = string
}

variable "number_broker_nodes" {
  description = "Number broker nodes"
  type        = number
  default     = 3
  validation {
    condition = var.number_broker_nodes >= 3
    error_message = "Number of broker nodes must be bigger than 3."
  }
}

variable "broker_instance_type" {
  description = "Instance type of broker nodes"
  type        = string
  default     = "t3.small"
}

variable "broker_ebs_volume_size" {
  description = "EBS volume size of broker nodes"
  type        = number
  default     = 50
}

variable "subnets" {
  description = "Subnets of MSK cluster"
  type        = list
  validation {
    condition = length(var.subnets) >= 3
    error_message = "Subnets from MSK cluster must be bigger than 3."
  }
}

variable "msk_tags" {
  description = "A map of tags to assign to the MSK."
  type        = map
  default     = {}
  validation {
    condition     = length(var.msk_tags) > 0
    error_message = "Tags from MSK is empty."
  }
}

variable "security_group_tags" {
  description = "A map of tags to assign to the AWS Security Group."
  type        = map
  default     = {}
  validation {
    condition     = length(var.security_group_tags) > 0
    error_message = "Tags from AWS Security Group is empty."
  }
}

variable "msk_security_group_rules" {
  description = "Rules of MSK Security Group"
  type = list(object({
    cidr_blocks = list(string)
    description = string
    from_port = number
    to_port = number
    protocol = string
    source_security_group_id = string
    self = bool
    type = string
  }))
  default = [{
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "Allow communicate to any IP."
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    source_security_group_id = ""
    self = false
    type              = "ingress"
  }]
}