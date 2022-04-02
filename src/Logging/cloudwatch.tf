#Create cloud watch log group 
variable "vpc_id" {
}
resource "aws_cloudwatch_log_group" "VPCFlow" {
    name = "VPC-Flow-${var.vpc_id}"
    retention_in_days = 30

    tags = {
        Name = "VPC-Flow ${var.vpc_id}"
    }
  
}