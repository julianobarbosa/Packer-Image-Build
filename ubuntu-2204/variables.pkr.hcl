variable "ADOServicePrincipalAppId" {
  type    = string
  default = "${env("ADOServicePrincipalAppId")}"
}

variable "client_id" {
  type    = string
  default = "${env("ADOServicePrincipalAppId")}"
}

variable "client_secret" {
  type    = string
  default = "${env("ADOServicePrincipalSecret")}"
}

variable "ADOServicePrincipalSecret" {
  type    = string
  default = "${env("ADOServicePrincipalSecret")}"
}

variable "Build_BuildNumber" {
  type    = string
  default = "${env("Build_BuildNumber")}"
}

variable "Build_DefinitionName" {
  type    = string
  default = "${env("Build_DefinitionName")}"
}

variable "ImageDestRG" {
  type    = string
  default = "${env("ImageDestRG")}"
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
  default = "${env("ImageGallery")}"
}

variable "Location" {
  type    = string
  default = "eastus"
}

variable "StorageAccountInstallersKey" {
  type    = string
  default = "${env("StorageAccountInstallersKey")}"
}

variable "StorageAccountInstallersName" {
  type    = string
  default = "${env("StorageAccountInstallersName")}"
}

variable "StorageAccountInstallersPath" {
  type    = string
  default = "${env("StorageAccountInstallersPath")}"
}

variable "Subnet" {
  type    = string
  default = "subnet-packer-image"
}

variable "SubscriptionId" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}

variable "ResourceGroup" {
  type    = string
  default = "${env("ARM_RESOURCE_GROUP")}"
}

variable "TempResourceGroup" {
  type    = string
  default = "${env("TempResourceGroup")}"
}

variable "TenantId" {
  type    = string
  default = "${env("ARM_TENANT_ID")}"
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
