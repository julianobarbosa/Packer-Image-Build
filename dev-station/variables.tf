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

// Variable for the Azure Bastion Host details
# variable "bastion_host" {
#   description = "The details of the Azure Bastion Host to be created"
#   type = object({
#     name                   = string 
#     sku                    = string // SKU of the Azure Bastion Host, either "Basic" or "Standard"
#     copy_paste_enabled     = bool 
#     file_copy_enabled      = bool 
#     ip_connect_enabled     = bool 
#     scale_units            = number /// Number of scale units for the Azure Bastion Host, between 2-50
#     shareable_link_enabled = bool 
#     tunneling_enabled      = bool 
#     ip_configuration = object({
#       name = string // Name of the IP configuration for the Azure Bastion Host.
#     })
#   })
# }

