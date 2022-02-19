variable "vpc_id" {
}

resource "aws_internet_gateway" "InetGW" {
  vpc_id = "${var.vpc_id}"

  tags = {
    "Name" = "Internet-Gateway"
  }
}

output "Internet-gateway-id" {
  value = "${aws_internet_gateway.InetGW.id}"
}
