resource "ec_deployment" "test_leader_pipeline" {
  name = "test-leader-pipeline"

  region                 = "eu-west-1"
  version                = "7.12.1"
  deployment_template_id = "aws-io-optimized-v2"

  elasticsearch {
    topology {
      id         = "hot_content"
      zone_count = 1
      size       = "15g"
    }
  }

  kibana {
    topology {
      zone_count = 1
      size       = "1g"
    }
  }

  observability {
    deployment_id = data.ec_deployment.logging.id
  }
}