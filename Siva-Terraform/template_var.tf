locals {
infra_secretmgr = yamldecode(data.aws_secretsmanager_secret_version.infra_secrets.secret_string)

template_vars = {
rds_password = local.infra_secretmgr.rds_password
}
 }

