variable "regras_entrada" {
  type = map(any)
  default = {
    101 = 80
    102 = 443
    103 = 22
    104 = 3389
  }
}
variable "prefixwin" {
  default     = "vmwin"
  description = "Prefix VM Windows"
}
variable "prefixlnx" {
  default     = "vmlnx"
  description = "Prefix VM Linux"
}