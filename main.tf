resource "random_password" "activepassword" {
  length  = var.passwordlength
  special = true
}

resource "random_password" "backup_password" {
  length  = var.passwordlength
  special = true
  keepers = {
    regen_trigger = var.rotate ? timestamp() : "no-change"
  }
}

resource "local_file" "password_output" {
  content  = jsonencode({
    activepassword = local.activepassword
    backup_password = local.backup_password
  })
  filename = "${path.module}/result.json"
}
