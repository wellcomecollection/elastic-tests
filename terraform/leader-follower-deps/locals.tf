locals {
  logging_cluster_id = var.logging_cluster_id
}

data "ec_deployment" "logging" {
  id = local.logging_cluster_id
}

data "ec_stack" "latest" {
  version_regex = "latest"
  region        = "us-east-1"
}