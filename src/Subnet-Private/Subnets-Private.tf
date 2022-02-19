data "aws_availability_zones" "azs" {}
variable "CIDR-Block" {
}

variable "vpc_id"{
    
}

resource "aws_subnet" "Private" {
    count   = "${length(data.aws_availability_zones.azs.names)}"
    availability_zone = data.aws_availability_zones.azs.names[count.index]
    vpc_id  = "${var.vpc_id}"
    cidr_block  = "${cidrsubnet(var.CIDR-Block,2,count.index)}"
    map_public_ip_on_launch = false

    tags = {
        Name  = "Private Subnet - ${data.aws_availability_zones.azs.names[count.index]}"
        Tier = "Private"
        AZ = "${data.aws_availability_zones.azs.names[count.index]}"
    }
}
output "Private-Subnet-cidr" {
  value = "${aws_subnet.Private.*.cidr_block}"
}
output "Private-subnet-id" {
  value = "${aws_subnet.Private.*.id}"
}
