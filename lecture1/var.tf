variable "resourcename" {
  description = "this is a resourcegroup"
  
  
}
variable "location" {
  validation {
    condition = can(regex("^North", var.location))
    error_message = "The location should be in North of europe ."
  }
}
variable "tags" {
  type = map
  default = { enviornment = "demo", owner = "shan", purpose = "TFdemo" }
}
