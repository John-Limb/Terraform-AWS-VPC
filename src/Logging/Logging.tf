variable "vpc_id" { 
}
#Configure logging into cloudwatch. 
resource "aws_flow_log" "VPCFlowLog" {
    iam_role_arn = aws_iam_role.FlowLogRole.arn
    traffic_type = "ALL"
    vpc_id = var.vpc_id
}

resource "aws_iam_role" "FlowLogRole" {
    name = "VPCFlowLog"

    assume_role_policy = <<EOF
    {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "FlowLogPolicy" {
    name = "VPCFlowLogPolicy"
    role = aws_iam_role.FlowLogRole.id

    policy = <<EOF
    {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
