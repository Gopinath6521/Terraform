module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
 
  domain_name  = trimsuffix(data.aws_route53_zone.mydomain.name, ".")
  zone_id      = data.aws_route53_zone.mydomain.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.ashwinenterprises2012.com"
  ]

  wait_for_validation = true
  tags = local.common_tags

}

output "acm_certificate_arn" {
  description = "value of the ACM certificate ARN"
  value       = module.acm.acm_certificate_arn
  
}