#!/bin/sh
echo 'Build packer image for ubuntu 22.04'

echo 'packer install plugins'
packer plugins install .

echo 'packer init'
packer init .

echo 'packer build image'
packer build .
