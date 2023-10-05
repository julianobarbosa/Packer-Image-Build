#!/bin/sh
echo 'Build packer image for ubuntu 22.04'
packer build -var-file=ubuntu-n590590-var.json ubuntu-n590590.json
