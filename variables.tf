data "aws_availability_zones" "azs" {}

variable "region" {
  default = "eu-west-2"
}

variable "CIDR-Block" {
  type = string
  default = "10.0.0.0/22"
}
variable "Public-CIDR" {
  type = string
  default = "10.0.0.0/24"
}
variable "Private-CIDR" {
  type = string
  default = "10.0.1.0/24"
}
variable "Restricted-CIDR" {
  type = string
  default = "10.0.2.0/24"
}