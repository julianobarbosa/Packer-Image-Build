SHELL := /bin/bash

.PHONY: init plan apply destroy

init:
	terraform init

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
