
resource "azuread_user" "usercretion" {
  display_name = "shantanu"
  password = "Supersecretpassword"
  user_principal_name = "shan@scaleupinfra.com"
  mail_nickname = "shan"
}

//output "password" {
//  value = nonsensitive(azuread_user.usercretion.password)
//}