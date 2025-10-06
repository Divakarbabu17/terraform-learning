
variable "rotate" {
  type = bool
  default = false  
}

variable "passwordlength" {
  type = number
  default = 16
}

resource "random_password" "activepassword" {
  length =  var.passwordlength
  special = true
  keepers = {
    
  }
}

resource "random_password" "backup_password" {
  length = var.passwordlength
  special = true
  keepers = {
    regen_trigger = var.rotate ?  timestamp() : "no-change"
  }
  
}

locals {
  activepassword = random_password.activepassword.result
}

resource "local_file" "password_output" {
  content  = jsonencode({
    activepassword = random_password.activepassword.result
    backup_password = random_password.backup_password.result
  })
  filename = "${path.module}/result.json"
}
