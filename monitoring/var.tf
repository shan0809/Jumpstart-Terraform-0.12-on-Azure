variable "email_reciever" {
  default =  [
    {
      email_address="shantanu_das90@outlook.com"
      name = "my email address"
    },
    {
      email_address="shantanuvdhfb_das90@outlook.com"
      name = "my email dummy2 address"
    }
  ]
}

variable "webhook_reciever" {
  default = {
    name = "mattermost"
    service_uri = "https://example.com"
  }
}
