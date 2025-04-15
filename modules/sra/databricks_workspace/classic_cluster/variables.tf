variable "resource_prefix" {
  description = "Prefix for the resource names."
  type        = string
}

variable "node_type_id" {
  description = "EC2 node type to use for the cluster"
  type        = string
}
