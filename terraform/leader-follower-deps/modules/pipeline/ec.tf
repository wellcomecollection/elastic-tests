# Leader
resource "ec_deployment" "pipeline" {
  for_each = toset(var.pipelines)
  name = "pipeline-${each.key}"
  region                 = "eu-west-1"
  version                = data.ec_stack.latest.version
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

# Followers
resource "ec_deployment" "api" {
  name                   = "api"
  region                 = "eu-west-1"
  version                = data.ec_stack.latest.version
  deployment_template_id = "aws-io-optimized-v2"

  elasticsearch {
    topology {
      id         = "hot_content"
      size       = "8g"
      zone_count = 3
    }

    dynamic "remote_cluster" {
      for_each = toset(var.pipelines)
      deployment_id = ec_deployment.pipeline[each.key].id
      alias         = ec_deployment.pipeline[each.key].name
      ref_id        = ec_deployment.pipeline[each.key].elasticsearch.0.ref_id
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

resource "ec_deployment" "rank" {
  name                   = "rank"
  region                 = "eu-west-1"
  version                = data.ec_stack.latest.version
  deployment_template_id = "aws-io-optimized-v2"

  elasticsearch {
    topology {
      id         = "hot_content"
      size       = "8g"
      zone_count = 3
    }

    dynamic "remote_cluster" {
      for_each = toset(var.pipelines)
      deployment_id = ec_deployment.pipeline[each.key].id
      alias         = ec_deployment.pipeline[each.key].name
      ref_id        = ec_deployment.pipeline[each.key].elasticsearch.0.ref_id
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
