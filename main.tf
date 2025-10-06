
variable "rotate" {
  type = bool
  default = false  
}

variable "swap" {
  type = bool
  default = false
  validation {
    condition = !(var.swap && var.rotate )
    error_message = "swap and rotation cannot be set at the same time. "
  
  }
  
}
variable "passwordlength" {
  type = number
  default = 16
}

resource "random_password" "activepassword" {
  length =  var.passwordlength
  special = true
 
}

resource "random_password" "backup_password" {
  length = var.passwordlength
  special = true
  keepers = {
    regen_trigger = var.rotate ?  timestamp() : "no-change"
  }
  
}

locals {
  activepassword = var.swap ? random_password.backup_password.result : random_password.activepassword.result
  backup_password = var.swap ? random_password.activepassword.result: random_password.backup_password.result  
}

resource "local_file" "password_output" {
  content  = jsonencode({
    activepassword = local.activepassword
    backup_password = local.backup_password
  })
  filename = "${path.module}/result.json"
}
