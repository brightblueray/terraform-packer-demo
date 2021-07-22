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



# Create a VPC - Virtual Private Cloud
resource "aws_vpc" "vpc_east" {
  provider             = aws.east
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
}

# resource "aws_vpc" "vpc_west" {
#     provider = aws.west
#     cidr_block = "10.0.0.0/16"
#     enable_dns_hostnames = true
# }

resource "aws_internet_gateway" "igw" {
  provider = aws.east
  vpc_id   = aws_vpc.vpc_east.id
}

resource "aws_subnet" "subnet_public" {
  provider   = aws.east
  vpc_id     = aws_vpc.vpc_east.id
  cidr_block = var.cidr_subnet
}

resource "aws_route_table" "rtb_public" {
  provider = aws.east
  vpc_id   = aws_vpc.vpc_east.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  provider       = aws.east
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}


resource "aws_security_group" "sg_east" {
  provider = aws.east

  name = "rryjewski-security-group"

  vpc_id = aws_vpc.vpc_east.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.prefix}-security-group"
  }
}

data "cloudinit_config" "foo" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "cloud-config"
    content      = file("scripts/go.yaml")
  }
}

# Create an instance from AMI
resource "aws_instance" "vm_east" {
  provider                    = aws.east
  ami                         = "ami-09e67e426f25ce0d7" #Lookup via Console Ubuntu 20.4
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  user_data                   = data.cloudinit_config.foo.rendered
  subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_east.id]
  tags = {
    Name = "rryjewski"
  }
}

output "public_ip" {
  value = aws_instance.vm_east.public_ip
}