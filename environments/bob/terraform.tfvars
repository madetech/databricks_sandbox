#Local use only!
#If you are using locally, then modify these:
resource_prefix    = "sandbox-bob"
admin_user         = "zeerak.aziz@madetech.com"

#Leave these:
region             = "eu-west-2"
region_name        = "london"
region_bucket_name = "sandbox-bucket-eu-west-2"
workspace_sku      = "PREMIUM"
metastore_exists      = false # first time false, change to true after UC is created once

enable_nat            = true
network_configuration = "isolated"
availability_zones    = ["eu-west-2a", "eu-west-2b"]

vpc_cidr_range                    = "10.0.0.0/16"
private_subnets_cidr              = ["10.0.10.0/24", "10.0.11.0/24"]
public_subnets_cidr               = ["10.0.20.0/24", "10.0.21.0/24"]
privatelink_subnets_cidr          = ["10.0.30.0/24", "10.0.31.0/24"]
sg_egress_ports                   = ["443", "2443", "6666", "8443", "8451"]
