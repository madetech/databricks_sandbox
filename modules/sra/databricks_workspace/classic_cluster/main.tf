# Terraform Documentation: https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster

# Cluster Version
data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

# Cluster Creation
resource "databricks_cluster" "ZA_dev_sandbox_cluster" {
  cluster_name            = "${var.node_type_id}-sandbox-cluster"
  data_security_mode      = "USER_ISOLATION"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = var.node_type_id
  autotermination_minutes = 15

  autoscale {
    min_workers = 1
    max_workers = 2
  }
  aws_attributes {
  availability     = "ON_DEMAND"
  ebs_volume_type  = "GENERAL_PURPOSE_SSD"
  ebs_volume_count = 1
  ebs_volume_size  = 100
  }
  lifecycle {
    ignore_changes = [autoscale,
    num_workers,
    custom_tags]
    create_before_destroy = true
  }
  no_wait = true

  # Derby Metastore configs
  spark_conf = {
    "spark.hadoop.datanucleus.autoCreateTables" : "true",
    "spark.hadoop.datanucleus.autoCreateSchema" : "true",
    "spark.hadoop.javax.jdo.option.ConnectionDriverName" : "org.apache.derby.jdbc.EmbeddedDriver",
    "spark.hadoop.javax.jdo.option.ConnectionPassword" : "hivepass",
    "spark.hadoop.javax.jdo.option.ConnectionURL" : "jdbc:derby:memory:myInMemDB;create=true",
    "spark.sql.catalogImplementation" : "hive",
    "spark.hadoop.javax.jdo.option.ConnectionUserName" : "hiveuser",
    "spark.hadoop.datanucleus.fixedDatastore" : "false"
  }

  # Custom Tags
  custom_tags = {
    "Project" = var.resource_prefix
  }
}
