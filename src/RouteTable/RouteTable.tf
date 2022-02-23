#here be the public route table
data "aws_availability_zones" "azs" {}
variable "vpc_id" {
}
variable "inet-gw-id" {
}
variable "public-subnet-id" {
}
variable "NatGateway" { 
}
variable "private-subnet-id" {
}
variable "Restricted-subnet-id" {
}
###################################### PUBLIC ########################################
resource "aws_route_table" "Public" {
  vpc_id = "${var.vpc_id}"

  tags = {
    "Name" = "Public Route Table"
  }
}
resource "aws_route" "Public_Internet" {
  route_table_id         = "${aws_route_table.Public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${var.inet-gw-id}"
}

resource "aws_route_table_association" "Public" {
  count          = "${length(data.aws_availability_zones.azs.names)}"
  subnet_id      = "${element(var.public-subnet-id, count.index)}"
  route_table_id = "${aws_route_table.Public.id}"
}
###################################### PRIVATE ########################################
resource "aws_route_table" "PrivateRouteTable" {
count = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id = "${var.vpc_id}"
  tags = {
      name = "Private Route Table ${count.index}"
  }   
}
resource "aws_route" "PrivateRoute" {
    count = "${length(data.aws_availability_zones.azs.names)}"
    route_table_id = "${element(aws_route_table.PrivateRouteTable.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "{element(var.NatGateway, count.index)}"
  
}
resource "aws_route_table_association" "Private-Route-Association" {
route_table_id = "${element(aws_route_table.PrivateRouteTable.*.id, count.index)}"
count =   "${length(data.aws_availability_zones.azs.names)}"
subnet_id = "${element(var.private-subnet-id, count.index)}"
}
###################################### Restricted ########################################
resource "aws_route_table" "Restricted" {
count = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id = "${var.vpc_id}"
  tags = {
      name = "Restricted Route Table ${count.index}"
  }   
}
resource "aws_route" "RestrictedRoute" {
    count = "${length(data.aws_availability_zones.azs.names)}"
    route_table_id = "${element(aws_route_table.Restricted.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "{element(var.NatGateway, count.index)}"
  
}
resource "aws_route_table_association" "Restricted-Route-Association" {
route_table_id = "${element(aws_route_table.Restricted.*.id, count.index)}"
count =   "${length(data.aws_availability_zones.azs.names)}"
subnet_id = "${element(var.Restricted-subnet-id, count.index)}"
}