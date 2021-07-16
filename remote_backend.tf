terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hashicorp-rryjewski"
    workspaces {
      name = "terraform-packer-demo"
    }
  }
}