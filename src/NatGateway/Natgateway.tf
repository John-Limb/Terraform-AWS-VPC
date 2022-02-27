data "aws_availability_zones" "azs" {}
variable "vpc_id" {
  
}
variable "Public-subnet-id" {
  
}

resource "aws_eip" "NatGateway" {
    count = "${length(data.aws_availability_zones.azs.names)}"
    vpc = true
  
}

resource "aws_nat_gateway" "NatGateway" {
    count = "${length(data.aws_availability_zones.azs.names)}"
    allocation_id = aws_eip.NatGateway.*.id[count.index]
    subnet_id = "${element(var.Public-subnet-id, count.index)}"
    
tags= {
    Name = "NatGateway ${data.aws_availability_zones.azs.names[count.index]}"
} 
}

output "Nat-Gateway-id" {
    value = "${aws_nat_gateway.NatGateway.*.id}"

}