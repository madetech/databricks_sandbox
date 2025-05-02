# EXPLANATION: Create the customer managed-vpc and security group rules

# VPC and other assets - skipped entirely in custom mode, some assets skipped for firewall and isolated
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  count   = var.network_configuration != "custom" ? 1 : 0

  name = "${var.resource_prefix}-classic-compute-plane-vpc"
  cidr = var.vpc_cidr_range
  azs  = var.availability_zones

  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  create_igw             = var.enable_nat

  public_subnet_names = [for az in var.availability_zones : format("%s-public-%s", var.resource_prefix, az)]
  public_subnets      = var.public_subnets_cidr

  private_subnet_names = [for az in var.availability_zones : format("%s-private-%s", var.resource_prefix, az)]
  private_subnets      = var.private_subnets_cidr

  intra_subnet_names = [for az in var.availability_zones : format("%s-privatelink-%s", var.resource_prefix, az)]
  intra_subnets      = var.privatelink_subnets_cidr

  # Disable features that cause dependency cycles if unused
  manage_default_route_table = false
  enable_vpn_gateway         = false
  enable_dhcp_options        = false
  enable_flow_log            = false

  #depends_on = [aws_nat_gateway.nat]
  depends_on = [time_sleep.wait_for_nat_cleanup]

  tags = {
    Project = var.resource_prefix
  }
}

# NAT Gateway setup for bootstrap access from private subnets
# resource "aws_eip" "nat" {
#   count = var.network_configuration != "custom" ? 1 : 0
#   domain = "vpc"
#   depends_on = [module.vpc]

# }

# resource "aws_nat_gateway" "nat" {
#   count         = var.network_configuration != "custom" ? 1 : 0
#   allocation_id = aws_eip.nat[0].id
#   subnet_id     = module.vpc[0].public_subnets[0] # Assumes VPC module includes public_subnets output
#   lifecycle {
#     create_before_destroy = true
#   }

#   depends_on    = [module.vpc,aws_eip.nat]
#   tags = {
#     Name = "${var.resource_prefix}-nat-gateway"
#   }
# }

resource "time_sleep" "wait_for_nat_cleanup" {
  count          = var.network_configuration != "custom" ? 1 : 0
  create_duration = "90s"
  depends_on     = [aws_nat_gateway.nat]
}


# resource "aws_route" "private_subnet_nat" {
#   count = var.network_configuration != "custom" && var.enable_nat ? length(module.vpc[0].private_route_table_ids) : 0

#   route_table_id         = element(module.vpc[0].private_route_table_ids, count.index)
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat[0].id

#   lifecycle {
#     create_before_destroy = true
#     ignore_changes        = [nat_gateway_id]
#   }

#   depends_on = [aws_nat_gateway.nat]
# }


# Security group - skipped in custom mode
resource "aws_security_group" "sg" {
  count = var.network_configuration != "custom" ? 1 : 0

  vpc_id     = module.vpc[0].vpc_id
  depends_on = [module.vpc]

  dynamic "ingress" {
    for_each = ["tcp", "udp"]
    content {
      description = "Databricks - Workspace SG - Internode Communication"
      from_port   = 0
      to_port     = 65535
      protocol    = ingress.value
      self        = true
    }
  }

  dynamic "egress" {
    for_each = ["tcp", "udp"]
    content {
      description = "Databricks - Workspace SG - Internode Communication"
      from_port   = 0
      to_port     = 65535
      protocol    = egress.value
      self        = true
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_ports
    content {
      description = "Databricks - Workspace SG - REST (443), Secure Cluster Connectivity (2443/6666), Future Extendability (8443-8451)"
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name    = "${var.resource_prefix}-workspace-sg"
    Project = var.resource_prefix
  }
}
