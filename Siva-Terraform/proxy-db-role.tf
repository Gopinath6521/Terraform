resource "aws_iam_role" "db_proxy_role" {
name   = "${var.env}-db-proxy-role"
assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "rds.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_db_proxy" {

 name         = "${var.env}-db-proxy-policy"
 path         = "/"
 description  = "AWS IAM Policy for managing aws proxy role"
 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GetSecretValue",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "DecryptSecretValue",
            "Action": [
                "kms:Decrypt"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "secretsmanager.ap-south-1.amazonaws.com"
                }
            }
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role_db_proxy" {
 role        = aws_iam_role.db_proxy_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_db_proxy.arn
}
