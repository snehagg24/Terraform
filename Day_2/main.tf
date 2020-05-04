variable "user" {
  type = string
}

resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
}

output "user_msg" {
  value = "Hi ${var.user}, your password is ${random_password.password.result}"
}