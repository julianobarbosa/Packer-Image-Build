# Copyright (c) Hypera Pharma.
# DevOps Team.
packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
  }
}

locals {
  build_by      = "Built by: HashiCorp Packer ${packer.version}"
  build_date    = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version = formatdate("YY.MM", timestamp())
  manifest_date = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path = "${path.cwd}/manifests/"
}

source "azure-arm" "image" {
  client_id                         = "{{ user `ADOServicePrincipalAppId` }}"
  client_secret                     = "{{ user `ADOServicePrincipalSecret` }}"
  image_offer                       = "{{ user `ImageOffer` }}"
  image_publisher                   = "{{ user `ImagePublisher` }}"
  image_sku                         = "{{ user `ImageSku` }}"
  location                          = "East US"
  managed_image_name                = "img-ubuntu-2204-{{isotime \"2006-01-02-1504\" | clean_resource_name}}"
  managed_image_resource_group_name = "{{ user `ImageDestRG` }}"
  os_type                           = "Linux"
  subscription_id                   = "{{ user `SubscriptionId` }}"
  tenant_id                         = "{{ user `TenantId` }}"
  vm_size                           = "Standard_DS2_v2"

  azure_tags = {
    Projeto    = "INFRA_SO"
    build-time = "{{ isotime \"2006-01-02-1504\" }}"
    department = "INFRA_SO"
    job        = "Golden Image"
    owner      = "INFRA_SO"
    task       = "Image deployment"
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
