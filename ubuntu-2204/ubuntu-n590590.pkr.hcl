# Copyright (c) Hypera Pharma.
# DevOps Team.
packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

source "azure-arm" "image" {
  client_id                         = var.ADOServicePrincipalAppId
  client_secret                     = var.ADOServicePrincipalSecret
  image_offer                       = var.ImageOffer
  image_publisher                   = var.ImagePublisher
  image_sku                         = var.ImageSku
  location                          = "East US"
  managed_image_name                = var.ImageName
  managed_image_resource_group_name = var.ImageDestRG
  os_type                           = "Linux"
  subscription_id                   = var.SubscriptionId
  tenant_id                         = var.TenantId
  vm_size                           = "Standard_DS2_v2"

  # shared_image_gallery_destination {
  #   subscription         = var.SubscriptionId
  #   resource_group       = var.ResourceGroup
  #   gallery_name         = var.ImageGallery
  #   image_name           = var.ImageName
  #   image_version        = formatdate("YYYY.MMDD.hhmm", timestamp())
  #   replication_regions  = [var.Location]
  #   storage_account_type = "Standard_LRS"
  # }

  azure_tags = {
    Projeto    = "INFRA_SO"
    build-time = "{{ isotime \"2006-01-02-1504\" }}"
    department = "INFRA_SO"
    job        = "Golden Image"
    owner      = "INFRA_SO"
    task       = "Image deployment"
    architecture = "x64"
  }
}

build {
  sources = ["source.azure-arm.image"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline_shebang  = "/bin/sh -x"
    scripts         = ["provision/scripts/azure.sh"]
  }
}
