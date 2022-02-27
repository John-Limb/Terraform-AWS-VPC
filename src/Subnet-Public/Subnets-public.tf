data "aws_availability_zones" "azs" {}
variable "CIDR-Block" {
}

variable "vpc_id"{
    
}
variable "Public-CIDR"{

}

resource "aws_subnet" "Public" {
    count   = "${length(data.aws_availability_zones.azs.names)}"
    availability_zone = data.aws_availability_zones.azs.names[count.index]
    vpc_id  = "${var.vpc_id}"
    cidr_block  = "${cidrsubnet(var.Public-CIDR,2,count.index)}"
    map_public_ip_on_launch = true

    tags = {
        Name  = "Public Subnet - ${data.aws_availability_zones.azs.names[count.index]}"
        Tier = "Public"
        AZ = "${data.aws_availability_zones.azs.names[count.index]}"
    }
}
resource "aws_network_acl" "public" {
    vpc_id = "${var.vpc_id}"
    subnet_ids = "${aws_subnet.Public.*.id}"

    egress {
        protocol = "-1"
        rule_no = "100"
        action = "allow"
        cidr_block = "0.0.0.0/0"
        to_port = "0"
        from_port = "0"

    }
    ingress {
        protocol = "-1"
        rule_no = "100"
        action = "allow"
        cidr_block = "0.0.0.0/0"
        to_port = "0"
        from_port = "0"
    }
    tags = {
        "Name" = "Public - ACL"
    }
}
output "Public-Subnet-cidr" {
  value = "${aws_subnet.Public.*.cidr_block}"
}
output "Public-Subnet-id" {
  value = "${aws_subnet.Public.*.id}"
}