resource "aws_iam_policy" "policy" {
  name        = "PCC-Policy-${random_string.suffix.id}"
  description = "Prisma Cloud Compute Policy"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateSecurityGroup",
                "ec2:DescribeSecurityGroups",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup",
                "ec2:RunInstances",
                "ec2:DescribeInstances",
                "ec2:TerminateInstances",
                "ec2:DescribeImages",
                "ec2:CreateTags",
                "ec2:AuthorizeSecurityGroupEgress",
                "lambda:GetFunction",
                "kms:Decrypt",
                "lambda:ListFunctions",
                "ecr:DescribeRepositories",
                "eks:DescribeCluster",
                "ecs:ListContainerInstances",
                "eks:ListClusters",
                "ecs:DescribeClusters",
                "ecs:ListClusters",
                "ec2:DescribeRegions",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings",
                "ssm:GetParameter",
                "secretsmanager:GetSecretValue",
                "ssm:ListDocuments",
                "secretsmanager:ListSecrets",
                "securityhub:BatchImportFindings",
                "lambda:PublishLayerVersion",
                "lambda:UpdateFunctionConfiguration",
                "lambda:GetLayerVersion",
                "lambda:GetFunctionConfiguration",
                "cloudwatch:DescribeAlarms",
                "apigateway:GET",
                "cloudfront:ListDistributions",
                "cloudwatch:GetMetricData",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeTargetGroups",
                "events:ListRules",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "lambda:GetFunction",
                "lambda:GetPolicy",
                "lambda:ListFunctions",
                "lambda:ListAliases",
                "lambda:ListEventSourceMappings",
                "logs:DescribeSubscriptionFilters",
                "kms:Decrypt",
                "s3:GetBucketNotification",
                "lambda:ListFunctions",
                "lambda:GetFunction",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "kms:Decrypt",
                "ec2:DescribeTags"
            ],
            "Resource": "*"
        }
    ]
}

EOT
}
