resource "aws_flow_log" "pc_flow" {
  iam_role_arn    = aws_iam_role.pc_flow_role.arn
  log_destination = aws_cloudwatch_log_group.utility_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.utility.id
  tags = {
    yor_trace = "90f570b2-8264-4969-911b-2ed940f9ad51"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_cloudwatch_log_group" "utility_flow_log" {
  name              = "utility_flow_log-${random_string.suffix.id}"
  retention_in_days = 1
  tags = {
    yor_trace = "75ed66a7-6c70-4f29-874c-6b63636781f7"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}