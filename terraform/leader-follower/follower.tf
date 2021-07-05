resource "ec_deployment" "test_follower_api" {
  name                   = "test-follower-api"
  region                 = "eu-west-1"
  version                = data.ec_stack.latest.version
  deployment_template_id = "aws-io-optimized-v2"

  elasticsearch {
    topology {
      id         = "hot_content"
      size       = "8g"
      zone_count = 3
    }

    remote_cluster {
      deployment_id = ec_deployment.test_leader_pipeline.id
      alias         = ec_deployment.test_leader_pipeline.name
      ref_id        = ec_deployment.test_leader_pipeline.elasticsearch.0.ref_id
    }
  }

  kibana {
    topology {
      size       = "1g"
      zone_count = 1
    }
  }

  observability {
    deployment_id = data.ec_deployment.logging.id
  }
}
