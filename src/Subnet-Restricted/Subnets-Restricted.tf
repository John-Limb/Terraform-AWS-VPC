data "aws_availability_zones" "azs" {}
variable "CIDR-Block" {
}

variable "vpc_id"{
    
}

resource "aws_subnet" "Restricted" {
    count   = "${length(data.aws_availability_zones.azs.names)}"
    availability_zone = data.aws_availability_zones.azs.names[count.index]
    vpc_id  = "${var.vpc_id}"
    cidr_block  = "${cidrsubnet(var.CIDR-Block,2,count.index)}"
    map_public_ip_on_launch = false

    tags = {
        Name  = "Restricted Subnet - ${data.aws_availability_zones.azs.names[count.index]}"
        Tier = "Restricted"
        AZ = "${data.aws_availability_zones.azs.names[count.index]}"
    }
}
output "Restricted-Subnet-cidr" {
  value = "${aws_subnet.Restricted.*.cidr_block}"
}
output "Restricted-Subnet-id" {
  value = "${aws_subnet.Restricted.*.id}"
}