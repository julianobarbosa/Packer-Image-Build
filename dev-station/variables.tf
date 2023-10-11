variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "ImageId" {
  type    = string
  default = "/subscriptions/51f4e493-4815-4858-8bbb-f263e7fb63d6/resourceGroups/rg-hypera-packer-image/providers/Microsoft.Compute/images/img-ubuntu-2204-2023-10-06-1941"
}

variable "Location" {
  type    = string
  default = "eastus"
}

variable "ResourceGroup" {
  type = string
}

variable "VMSize" {
  type    = string
  default = ""
}

variable "VirtualNetwork" {
  type    = string
  default = "vnet-packer-image"
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed."
  type        = map(any)

  default = {
    name                  = "DevOps Teams"
    tier                  = "Infrastructure"
    application           = "DevOps"
    applicationversion    = "1.0.0"
    environment           = "Sandbox"
    infrastructureversion = "1.0.0"
    projectcostcenter     = "0570025003"
    operatingcostcenter   = "0570025003"
    owner                 = "INFRA_SO"
    securitycontact       = "juliano.barbosa@hypera.com.br"
    confidentiality       = "PII/PHI"
    compliance            = "HIPAA"
    source                = "terraform"
    projeto               = "INFRA_SO"
    team                  = "DevOps"
  }
}

