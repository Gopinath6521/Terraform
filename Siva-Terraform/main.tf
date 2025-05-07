data "aws_secretsmanager_secret_version" "infra_secrets" {
  depends_on = [
   "resource.aws_secretsmanager_secret.password","aws_db_subnet_group.db-subnet"
]
secret_id = "${var.env}-db-password8"
}
