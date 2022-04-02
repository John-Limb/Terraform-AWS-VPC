terraform {
  backend "s3" {
    #define bucket and key
    bucket = "var.bucket"
    key    = "var.key"
    region = "eu-west-2"

    #define dynamo DB tables to use
    dynamodb_table = "var.dynamodb_table"
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
  CIDR-Block = "${var.CIDR-Block}"
  Private-CIDR = "${var.Private-CIDR}"
  vpc_id = aws_vpc.Main.id
}
module "Restricted-Subnets" {
  source                  = "./src/Subnet-Restricted"
  CIDR-Block = "${var.CIDR-Block}"
  Restricted-CIDR = "${var.Restricted-CIDR}"
  vpc_id = aws_vpc.Main.id
}
module "InetGW" {
  source = "./src/InetGW"
  vpc_id = aws_vpc.Main.id
}
module "RouteTables" {
  source = "./src/RouteTable"
  vpc_id = aws_vpc.Main.id
  inet-gw-id = module.InetGW.Internet-gateway-id
  public-subnet-id = module.Public-Subnets.Public-Subnet-id
  private-subnet-id = module.Private-Subnets.Private-subnet-id
  Restricted-subnet-id = module.Restricted-Subnets.Restricted-Subnet-id
  NatGateway = module.NatGateway.Nat-Gateway-id

}
module "NatGateway"{
  source = "./src/NatGateway"
  vpc_id = aws_vpc.Main.id
  Public-subnet-id = module.Public-Subnets.Public-Subnet-id
} 
module "Logging"{
  source = "./src/Logging"
  vpc_id = aws_vpc.Main.id
}
