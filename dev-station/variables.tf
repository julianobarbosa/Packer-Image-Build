variable "ADOServicePrincipalAppId" {
  type    = string
}

variable "client_id" {
  type    = string
}

variable "client_secret" {
  type    = string
}

variable "ADOServicePrincipalSecret" {
  type    = string
}

variable "Build_BuildNumber" {
  type    = string
}

variable "Build_DefinitionName" {
  type    = string
}

variable "ImageId" {
  type    = string
  default = "/subscriptions/51f4e493-4815-4858-8bbb-f263e7fb63d6/resourceGroups/rg-hypera-packer-image/providers/Microsoft.Compute/images/img-ubuntu-2204-2023-10-06-1941"
}

variable "ImageDestRG" {
  type    = string
}

variable "ImageOffer" {
  type    = string
  default = "0001-com-ubuntu-server-jammy"
}

variable "ImagePublisher" {
  type    = string
  default = "canonical"
}

variable "ImageSku" {
  type    = string
  default = "22_04-lts"
}

variable "ImageName" {
  type    = string
  default = "img-ubuntu-2204-{{ isotime \"2006-01-02-1504\" }}"
}

variable "ImageGallery" {
  type    = string
}

variable "Location" {
  type    = string
  default = "eastus"
}

variable "StorageAccountInstallersKey" {
  type    = string
}

variable "StorageAccountInstallersName" {
  type    = string
}

variable "StorageAccountInstallersPath" {
  type    = string
}

variable "Subnet" {
  type    = string
  default = "subnet-packer-image"
}

variable "SubscriptionId" {
  type    = string
}

variable "ResourceGroup" {
  type    = string
}

variable "TempResourceGroup" {
  type    = string
}

variable "TenantId" {
  type    = string
}

variable "VMSize" {
  type    = string
  default = ""
}

variable "VirtualNetwork" {
  type    = string
  default = "vnet-packer-image"
}

variable "VirtualNetworkRG" {
  type    = string
  default = "rg-hypera-packer-image"
}
