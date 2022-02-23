data "aws_availability_zones" "azs" {}
variable "CIDR-Block" {
}

variable "vpc_id"{
    
}
variable "Restricted-CIDR" {
  
}
resource "aws_subnet" "Restricted" {
    count   = "${length(data.aws_availability_zones.azs.names)}"
    availability_zone = data.aws_availability_zones.azs.names[count.index]
    vpc_id  = "${var.vpc_id}"
    cidr_block  = "${cidrsubnet(var.Restricted-CIDR,2,count.index)}"
    map_public_ip_on_launch = false

    tags = {
        Name  = "Restricted Subnet - ${data.aws_availability_zones.azs.names[count.index]}"
        Tier = "Restricted"
        AZ = "${data.aws_availability_zones.azs.names[count.index]}"
    }
}

resource "aws_network_acl" "Restricted" {
    vpc_id = "${var.vpc_id}"
    subnet_ids = "${aws_subnet.Restricted.*.id}"

    egress {
        protocol = "-1"
        rule_no = "100"
        action = "allow"
        cidr_block = "${var.CIDR-Block}"
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
        "Name" = "Restricted - ACL"
    }
}
output "Restricted-Subnet-cidr" {
  value = "${aws_subnet.Restricted.*.cidr_block}"
}
output "Restricted-Subnet-id" {
  value = "${aws_subnet.Restricted.*.id}"
}