resource "aws_iam_role" "lambda_role" {
  name               = "subprocessLambdaRole-${random_string.suffix.result}"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  tags = {
    yor_trace = "0cd3b986-103f-4bed-a87c-94b6ce29117f"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
  tags = {
    yor_trace = "ba793661-8cc8-44a1-ad92-23074b24221b"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/subprocess.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/python/subprocess.zip"
  function_name = "subprocessLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "subprocess.lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  tags = {
    yor_trace = "cea55548-c2bb-4819-9349-fb2f86b48ab0"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}
