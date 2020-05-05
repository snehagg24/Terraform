output "user_msg" {
  value = "Hi ${var.user}, your password is ${random_password.password.result}"
}