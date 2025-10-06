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
