SHELL := /bin/bash

.PHONY: init plan apply destroy

init:
	terraform init

recreate:
	terraform apply -replace "azurerm_linux_virtual_machine.azxdev01" 

refresh:
	terraform plan --refresh-only

fmt:
	terraform fmt -recursive

plan: validate
	terraform plan -out tfplan

apply:
	terraform apply tfplan

destroy:
	terraform destroy

validate:
	terraform validate

checkov:
	checkov --directory .
