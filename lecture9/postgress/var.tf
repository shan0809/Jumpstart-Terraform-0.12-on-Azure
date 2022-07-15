variable "postgres_version" {
  default = "11"
}

variable "storage_profile_postress" {
  default = [5120, 7 , true]
}

variable "firewall_rules" {

  default = [
    {
      name = "internal_communication",
      start_ip = "0.0.0.0",
      end_ip = "0.0.0.0"
    }
  ]
}


variable "db_name" {
  default = ["db1"]
}