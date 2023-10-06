variable "ADOServicePrincipalAppId" {
  type    = string
  default = "${env("ADOServicePrincipalAppId")}"
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
  default = ""
}

variable "SubscriptionId" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}

variable "TempResourceGroup" {
  type    = string
  default = "${env("TempResourceGroup")}"
}

variable "TenantId" {
  type    = string
  default = "${env("ARM_TENANT_ID")}"
}

variable "VMName" {
  type    = string
  default = "azxdev01"
}

variable "VMSize" {
  type    = string
  default = ""
}

variable "VirtualNetwork" {
  type    = string
  default = ""
}

variable "VirtualNetworkRG" {
  type    = string
  default = ""
}
