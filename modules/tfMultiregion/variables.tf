variable "region" {
  default     = "us-east-1"
  description = "The AWS region the resouce will be deployed to"
}

variable "prefix" {
  description = "This prefix will be included in the name of most resources."
  default     = "rryjewski"
}

variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}
