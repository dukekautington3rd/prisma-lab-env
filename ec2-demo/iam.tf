resource "aws_iam_role" "pc_flow_role" {
  name = "pc_flow_role"

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
  tags = {
    yor_trace = "531ad167-0772-4a11-967c-c6ace1f399c9"
  }
}

resource "aws_iam_role_policy" "pc_flow_policy" {
  name = "pc_flow_policy"
  role = aws_iam_role.pc_flow_role.id

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

resource "aws_iam_role" "ssm_role_tf" {
  name = "ssm_role_tf_${random_string.suffix.id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF
  tags = {
    yor_trace = "e561000c-a565-40d2-80a8-47f65fb15203"
  }
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.ssm_role_tf.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_instance_profile" "ssm_mgr_policy" {
  name = "ssm_mgr_tf_${random_string.suffix.id}"
  role = aws_iam_role.ssm_role_tf.name
  tags = {
    yor_trace = "94825cd1-2400-444e-8a4c-4e0d09d1e9ae"
  }
}