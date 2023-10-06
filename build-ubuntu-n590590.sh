#!/bin/sh
echo 'Build packer image for ubuntu 22.04'

echo 'packer install plugins'
packer plugins install -var-file=ubuntu-n590590-var.pkr.hcl ubuntu-n590590.pkr.hcl

echo 'packer init'
packer init -var-file=ubuntu-n590590.pkr.hcl ubuntu-n590590.pkr.hcl

echo 'packer build image'
packer build -var-file=ubuntu-n590590.pkr.hcl ubuntu-n590590.pkr.hcl
