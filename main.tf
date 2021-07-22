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

# Declare Provider for West Coast
provider "aws" {
  alias  = "aws_west"
  region = "us-west-2"
  max_retries = 5
  default_tags {
      tags = {
          Environment = "Sandbox"
          Name = "rryjewski-sandbox"
      }
  }
}

# Declare Provider for East Coast
provider "aws" {
  alias  = "aws_east"
  region = "us-east-2"
  max_retries = 5
    default_tags {
      tags = {
          Environment = "Sandbox"
          Name = "rryjewski-sandbox"
      }
  }
}

# Provision Common Resources
module "common-us-east-2" {
  source = "./modules/common"
  
  providers = {
    aws = aws.aws_east
   }
}

module "common-us-west-2" {
  source = "./modules/common"
  
  providers = {
    aws = aws.aws_west
   }
}



# # Provision VM with Webapp using TF and cloud-init
# module "cloudInit-us-east-2" {
#   source = "./modules/tfMultiRegion"
#   name = "rryjewski_us-east"
  
#   providers = {
#     aws = aws.aws_east
#    }
# }

# module "cloudInit-us-west-2" {
#   source = "./modules/tfMultiRegion"
#   name = "rryjewski_us-west"
  
#   providers = {
#     aws = aws.aws_west
#    }
# }

# # Provision VM with Webapp created with Packer
# # TODO Update Module to use data to lookup AMI image
# module "packer-us-east-2" {
#   source = "./modules/usingPacker"
#   name = "rryjewski_us-east"
#   ami    = "ami-077c040dca9513fd1"

#   providers = {
#     aws = aws.aws_east
#    }
# }

# module "packer-us-west-2" {
#   source = "./modules/usingPacker"
#   name = "rryjewski_us-west"
#   ami = "ami-005fabf6cd9b261af"

#   providers = {
#     aws = aws.aws_west
#    }
# }

