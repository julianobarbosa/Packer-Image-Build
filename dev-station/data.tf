data "cloudinit_config" "azxdev01-cloud-init" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/files/ansible-pull.yaml")
  }
}
