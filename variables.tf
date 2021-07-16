variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "Learn"
}

# variable  "ami_map" {
#   type = list(object({
#     region = string
#     ami = string
#   }))
# }

# variable "region_east" {
#   description = "Default region in east"
#   default = "us-east-2"
# }

# variable "region_west" {
#   description = "Default region in west"
#   default = "us-west-2"
# }