resource "aws_security_group" "compute-lambda-sg" {
  name        = "${var.env}-${var.compute-lambda-name}-sg"
#  description = format("security group for vpc endpoint for %s")
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "from my ip range"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.vpccidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
    tags = {
       "Name" = "${var.env}-${var.compute-lambda-name}-sg"
     }
}

resource "aws_lambda_permission" "with_compute_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.compute-lambda.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.compute-tg.arn
}

resource "aws_lambda_function" "compute-lambda" {
  function_name = "${var.env}-${var.compute-lambda-name}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "Lambda.handler"
  runtime       = "nodejs16.x"
  memory_size   = 256
  timeout       = 300 
  s3_bucket     = var.compute-lambda-name-s3
  s3_key        = var.compute-lambda-name-s3-path
  depends_on    = ["aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role","aws_vpc.vpc","aws_db_instance.mydb1"]

  vpc_config {
    subnet_ids         = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id, aws_subnet.pubsub3.id]
    security_group_ids = [aws_security_group.compute-lambda-sg.id]
  }
#  environment {
#    variables = {
#      AWS_IAM_KEY            = "aws-key-lambda"
#      AWS_IAM_SECRET         = "aws-key-lambda"
#      BC_SQS_URL             = "https://sqs.ap-south-1.amazonaws.com/876529261348/cf-game-queue-dev02"
#      BUCKET_NAME            = "coinfantasy-assets-dev02"
#      COIN_GECKO_HOST        = "https://api.coingecko.com"
#      CRON_USER              = "system.cron"
#      DB_CONFIG              = "dev02.aws.lambda"
#      DB_HOST                = "cf-main-dev02.c7ddph3rjtx8.ap-south-1.rds.amazonaws.com"
#      DB_MAIN_DATABASE       = "cf_main"
#      DB_PASSWORD            = "data.aws_secretsmanager_secret_version.password"
#      DB_USER_NAME           = "cf_main_db"
#      DEF_LANGUAGE           = "en"
#      EMAIL_AWS_IAM_KEY      = "AKIAQPO5ZTEI52ZSSYHC"
#      EMAIL_AWS_IAM_SECRET   = "${var.EMAIL_AWS_IAM_SECRET}"
#      EMAIL_HOST             = "in-v3.mailjet.com"
#      ENABLE_CUSTOMER_EMAIL  = "true"
#      ENABLE_SIMULATE_GAMES  = "false"
#      ENV                    = "dev02.lambda"
#      GE_SQS_URL             = "https://sqs.ap-south-1.amazonaws.com/876529261348/cf-game-engine-queue-dev02"
#      JWT_ENCRYPTION_KEY     = "development_secret"
#      MAILJET_API_KEY        = "72970a29b05e42e98cd1d504dc4def41"
#      MAILJET_HOST           = "https://api.mailjet.com"
#      NAKAMA_HOST            = "https://cf-rts-dev02.devcoinfantasy.co.in:7350"
#      NAKAMA_LOCAL_HOST_URLS = "$NAKAMA_LOCAL_HOST_URLS"
#      NAME_API_API_KEY       = "94fb91e578785aa8f18e287368d8c4e2-user1"
#      NAME_API_HOST          = "https://api.nameapi.org"
#      RECAPTCHA_HOST         = "https://www.google.com/recaptcha/api/siteverify"
#      RECAPTCHA_SECRET_KEY   = "${var.RECAPTCHA_SECRET_KEY}"
#      REPORTING_EMAIL        = "donotreply@coinfantasy.io"
#      S3_PUBLIC_URI          = "https://coinfantasy-assets-dev02.s3.ap-south-1.amazonaws.com"
#      SERVER_PUBLIC_URL      = ""
#      SIMULATE_EMAIL_OTP     = "true"
#      SIMULATE_MOBILE_OTP    = "true"
#      SKIP_EMAIL             = "false"
#      SKIP_SMS               = "false"
#      SMS_SENDER_ID          = "coinfantasy"
#      SMTP_EMAIL             = "donotreply@coinfantasy.io"
#      SMTP_PASSWORD          = "${var.SMTP_PASSWORD}"
#     SMTP_USER_ID           = "dc26164ba1243b6f61dacd4ffdf0a152"
#      SNS_MAX_PRICE          = "0.5"
#      SUPPORT_EMAIL          = "donotreply@coinfantasy.io"
#     SYSTEM_ADMIN           = "system.admin"
#      WEB3_ADMIN             = "system.chain.admin"
#      npm_package_name       = "cf-profile-service"
#      npm_package_version    = "V-1.1.22-B0470"
#    }
#  }
}

resource "aws_lb_target_group" "compute-tg" {
  name        = "${var.env}-${var.compute-lambda-name}-tg"
  target_type = "lambda"
  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "5"    
    path                = "/api/compute/ping"
  }
}
resource "aws_lb_target_group_attachment" "compute" {
  target_group_arn = aws_lb_target_group.compute-tg.arn
  target_id        = aws_lambda_function.compute-lambda.arn
}

