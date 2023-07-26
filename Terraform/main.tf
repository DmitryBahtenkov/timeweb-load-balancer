terraform {
  required_providers {
    twc = {
        source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = ">= 1.5.3"
}

provider "twc" {
  token = var.tw_token
}

data "twc_lb_preset" "lb-preset" {
  requests_per_second = "10K"
  price_filter {
    from = 100
    to = 200
  }
}

data "twc_projects" "articles" {
  name = "Articles"
}

resource "twc_lb" "load-balancer" {
    name = "load-balancer"
    algo = "roundrobin"
    
    project_id = data.twc_projects.articles.id
    preset_id = data.twc_lb_preset.lb-preset.id

    health_check {
      proto = "tcp"
      port = 80
    }
    
    ips = var.lb-ips
}

resource "twc_lb_rule" "lb-rule" {
  lb_id = resource.twc_lb.load-balancer.id

  balancer_proto = "http"
  balancer_port = 80
  server_proto = "http"
  server_port = 80
}

resource "twc_lb_rule" "lb-second-rule" {
  lb_id = resource.twc_lb.load-balancer.id

  balancer_proto = "http"
  balancer_port = 81
  server_proto = "http"
  server_port = 81
}
