resource "aws_route53_record" "my_dns" {
    zone_id = data.aws_route53_zone.mydomain.zone_id
    name    = "apps.ashwinenterprises2012.com"
    type = "A"
    # ttl = 300
    alias {
        name                   = module.alb.dns_name
        zone_id                = module.alb.zone_id
        evaluate_target_health = true
    }
}