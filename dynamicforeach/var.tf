variable "backend_pool" {

  type = list(object({
    name = string
    load_balancing_name =  string
    health_probe_name = string
    backend =  list(object({
      host_header = string
      address     = string
      http_port   = string
      https_port  = string
    }))
  }))


  default = [
    {
      name = "exampleBackendBing"
      load_balancing_name = "exampleLoadBalancingSettings1"
      health_probe_name = "exampleHealthProbeSetting1"
      backend = [
        {
          host_header = "www.bing.com"
          address = "www.bing.com"
          http_port = "80"
          https_port = "443"
        }]
    },
    {
      name = "exampleBackendBing1"
      load_balancing_name = "exampleLoadBalancingSettings1"
      health_probe_name = "exampleHealthProbeSetting1"
      backend = [
        {
          host_header = "www.bing.com"
          address = "www.bing.com"
          http_port = "80"
          https_port = "443"
        }]
    },
    {
      name = "exampleBackendBing2"
      load_balancing_name = "exampleLoadBalancingSettings1"
      health_probe_name = "exampleHealthProbeSetting1"
      backend = [
        {
          host_header = "www.bing.com"
          address = "www.bing.com"
          http_port = "80"
          https_port = "443"
        }]
    }

  ]

}

variable "routing_rule" {
  default = [
    {
      name               = "exampleRoutingRule1"
      accepted_protocols = ["Http", "Https"]
      patterns_to_match  = ["/98"]
      frontend_endpoints = ["exampleFrontendEndpoint1"]
      forwarding_configuration = [{
    forwarding_protocol = "MatchRequest"
    backend_pool_name   = "exampleBackendBing"
    }]
    },
    {
      name               = "exampleRoutingRule2"
      accepted_protocols = ["Http", "Https"]
      patterns_to_match  = ["/89"]
      frontend_endpoints = ["exampleFrontendEndpoint1"]
      forwarding_configuration = [{
        forwarding_protocol = "MatchRequest"
        backend_pool_name   = "exampleBackendBing1"
      }]
    },
    {
      name               = "exampleRoutingRule3"
      accepted_protocols = ["Http", "Https"]
      patterns_to_match  = ["/*"]
      frontend_endpoints = ["exampleFrontendEndpoint1"]
      forwarding_configuration = [{
        forwarding_protocol = "MatchRequest"
        backend_pool_name   = "exampleBackendBing2"
      }]
    }

  ]
}

