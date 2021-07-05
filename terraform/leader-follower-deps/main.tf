module "pipelines" {
  pipelines = ["2021-07-05", "2021-07-01"]
  source    = "./modules/pipeline"
}