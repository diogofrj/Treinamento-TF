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



variable "prefix" {
  default     = "TestVM"
  description = "Prefix Instances"
}

variable "region_onprem" {
  default     = "eastus"
  description = "Região Onpremises"
}

variable "region_core" {
  default     = "westus"
  description = "Região Core"
}
variable "region_fabric" {
  default     = "northeurope"
  description = "Região Manufacture"
}
variable "region_research" {
  default     = "westindia"
  description = "Região Research"
}

variable "tags" {
  type        = map(any)
  description = "tags"
  default = {
    "env" = "AZ-700"
  }
}

