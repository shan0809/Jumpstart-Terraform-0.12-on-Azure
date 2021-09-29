provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "frontdoorRG"
  location = "West Europe"
}

resource "azurerm_frontdoor" "example" {
  name                                         = "shanFrontDoor"
  resource_group_name                          = azurerm_resource_group.example.name
  enforce_backend_pools_certificate_name_check = false

  dynamic "routing_rule" {
    for_each = var.routing_rule
    content {
      name               = routing_rule.value["name"]
      accepted_protocols = routing_rule.value["accepted_protocols"]
      patterns_to_match  = routing_rule.value["patterns_to_match"]
      frontend_endpoints = routing_rule.value["frontend_endpoints"]
      dynamic "forwarding_configuration" {
        for_each = routing_rule.value["forwarding_configuration"]
        content {
          forwarding_protocol = forwarding_configuration.value["forwarding_protocol"]
          backend_pool_name   = forwarding_configuration.value["backend_pool_name"]
        }
      }
    }
  }

  backend_pool_load_balancing {
    name = "exampleLoadBalancingSettings1"
  }

  backend_pool_health_probe {
    name = "exampleHealthProbeSetting1"
  }

  dynamic "backend_pool" {

    for_each = var.backend_pool
    content {
      health_probe_name = backend_pool.value["health_probe_name"]
      load_balancing_name = backend_pool.value["load_balancing_name"]
      name = backend_pool.value["name"]

      dynamic "backend" {
        for_each = backend_pool.value["backend"]
        content {
          address = backend.value["address"]
          host_header = backend.value["host_header"]
          http_port = backend.value["http_port"]
          https_port = backend.value["https_port"]
        }
      }
    }
  }

  frontend_endpoint {
    name      = "exampleFrontendEndpoint1"
    host_name = "shanFrontDoor.azurefd.net"
  }
}