terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.46.0"
      configuration_aliases = [ aws.aws_east, aws.aws_west ]
    }
  }
  required_version = "> 0.14.5"
}

provider "aws" {
  alias  = "aws_west"
  region = "us-west-2"
  max_retries = 5
  default_tags {
      tags = {
          Environment = "Test"
          Name = "rryjewski-sandbox"
      }
  }
}

provider "aws" {
  alias  = "aws_east"
  region = "us-east-2"
  max_retries = 5
    default_tags {
      tags = {
          Environment = "Test"
          Name = "rryjewski-sandbox"
      }
  }
}

module "us-east-2" {
  source = "./modules/multi-region"
  name = "rryjewski_us-east"
  ami    = "ami-077c040dca9513fd1"

  providers = {
    aws = aws.aws_east
   }
}

module "us-west-2" {
  source = "./modules/multi-region"
  name = "rryjewski_us-west"
  ami = "ami-005fabf6cd9b261af"

  providers = {
    aws = aws.aws_west
   }
}

