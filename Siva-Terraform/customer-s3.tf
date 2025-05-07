# S3 bucket for customer site.
resource "aws_s3_bucket" "customer_bucket" {
  bucket = "${var.env}-${var.s3_customer_bucket_name}"
  acl    = "public-read"
#  policy = data.aws_iam_policy_document.allow_public_s3_read.json

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.customer_domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = var.common_tags
}
#data "aws_iam_policy_document" "allow_public_s3_read" {
  #statement {
    #sid    = "PublicReadGetObject"
    #effect = "Allow"

    #actions = [
      #"s3:GetObject",
    #]

    #principals {
      #type        = "AWS"
     # identifiers = ["*"]
   # }

    #resources = [
   #   "arn:aws:s3:::${var.s3_admin_bucket_name}/*"

  #  ]
 # }
#}
