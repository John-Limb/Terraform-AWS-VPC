data "aws_availability_zones" "azs" {}
variable "CIDR-Block" {
}

variable "vpc_id"{
    
}
variable "Private-CIDR"{

}

resource "aws_subnet" "Private" {
    count   = "${length(data.aws_availability_zones.azs.names)}"
    availability_zone = data.aws_availability_zones.azs.names[count.index]
    vpc_id  = "${var.vpc_id}"
    cidr_block  = "${cidrsubnet(var.Private-CIDR,2,count.index)}"
    map_public_ip_on_launch = false

    tags = {
        Name  = "Private Subnet - ${data.aws_availability_zones.azs.names[count.index]}"
        Tier = "Private"
        AZ = "${data.aws_availability_zones.azs.names[count.index]}"
    }
}

resource "aws_network_acl" "Private" {
    vpc_id = "${var.vpc_id}"
    subnet_ids = "${aws_subnet.Private.*.id}"

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
        "Name" = "Private - ACL"
    }
}

output "Private-Subnet-cidr" {
  value = "${aws_subnet.Private.*.cidr_block}"
}
output "Private-subnet-id" {
  value = "${aws_subnet.Private.*.id}"
}
