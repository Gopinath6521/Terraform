data "aws_route53_zone" "mydomain" {
  name         = "ashwinenterprises2012.com"
}

output "my_domain_zone_id" {
  description = "value of the Route53 zone id"
  value       = data.aws_route53_zone.mydomain.zone_id
}

output "my_domain_name" {
  description = "value of the Route53 zone name"
  value       = data.aws_route53_zone.mydomain.name
  
}