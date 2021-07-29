/*
Terraform Block - Used to configure behavior of Terraform.  Can be used to specify version constraint of Terraform
and specifying required providers.
*/
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 3.46.0"
    }
  }
}

# Pass the VM Base Image to use
variable "ami" {}
variable "subnet_id" {}
variable "security_group_id" {}

data "cloudinit_config" "foo" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "cloud-config"
    content      = file("scripts/go.yaml")
  }
}

# Create an instance from AMI
resource "aws_instance" "vm" {
  provider                    = aws
  ami                         = var.ami
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  user_data                   = data.cloudinit_config.foo.rendered
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
}

output "public_ip" {
  value = aws_instance.vm.public_ip
}