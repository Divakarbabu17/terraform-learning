locals {
  activepassword  = var.swap ? random_password.backup_password.result : random_password.activepassword.result
  backup_password = var.swap ? random_password.activepassword.result : random_password.backup_password.result  
}
