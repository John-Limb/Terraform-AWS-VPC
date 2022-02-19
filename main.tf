terraform {
  backend "s3" {
    #define bucket and key
    bucket = "terraform-state-980971185860"
    key    = "VPC/terraform.tfstate"
    region = "eu-west-2"

    #define dynamo DB tables to use
    dynamodb_table = "terraform-locks-980971185860"
    encrypt        = true
  }
}
provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}



#Defining VPC and CIDR
resource "aws_vpc" "Main" {
  cidr_block           = "${var.CIDR-Block}"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  

  tags = {
    Name = "Main"
    Type = "prod"
  }
}

module "Public-Subnets" {
  source                  = "./src/Subnet-public"
  CIDR-Block = "${var.CIDR-Block}"
  Public-CIDR = "${var.Public-CIDR}"
  vpc_id = aws_vpc.Main.id
}
module "Private-Subnets" {
  source                  = "./src/Subnet-Private"
  CIDR-Block = "${var.Private-CIDR}"
  vpc_id = aws_vpc.Main.id
}
module "Restricted-Subnets" {
  source                  = "./src/Subnet-Restricted"
  CIDR-Block = "${var.Restricted-CIDR}"
  vpc_id = aws_vpc.Main.id
}
module "InetGW" {
  source = "./src/InetGW"
  vpc_id = aws_vpc.Main.id
}