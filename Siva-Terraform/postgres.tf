resource "aws_db_subnet_group" "db-subnet" {
  name       = "${var.env}-db-subnet-grp"
  depends_on = ["aws_vpc.vpc"]

  subnet_ids = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id, aws_subnet.pubsub3.id]
}
resource "random_password" "rds_password"{
  length           = 16
  special          = true
  override_special = "_!%^"
}
locals{
rds_password     = resource.random_password.rds_password.result
rds_password_app = urlencode(local.rds_password)
rds_username     = "${var.db-username}"
rds_endpoint     = aws_db_instance.mydb1.endpoint
}
resource "aws_secretsmanager_secret" "password" {
  name = "${var.env}-db-password8"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = jsonencode({ rds_password = local.rds_password })
}

resource "aws_security_group" "mydb1" {
  name = "${var.env}-${var.db-username}-sg"

  description = "RDS postgres servers (terraform-managed)"
  vpc_id      = aws_vpc.vpc.id

  # Only postgres in
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.env}-${var.db-username}-sg"
  }

}


resource "aws_db_instance" "mydb1" {
  depends_on = [
   "resource.aws_secretsmanager_secret.password","aws_db_subnet_group.db-subnet"
]
  allocated_storage       = "${var.db_size}" # gigabytes
  backup_retention_period = 7   # in days
  db_subnet_group_name    = "${var.env}-db-subnet-grp"
  engine                  = "postgres"
  engine_version          = var.engine_version
  identifier              = "${var.env}-${var.db-username}"
  instance_class          = var.instance_class
  multi_az                = true
  name                    = var.db_name
  parameter_group_name    = "default.postgres13" # if you have tuned it
  password                = local.rds_password
  port                    = 5432
  publicly_accessible     = true
  storage_encrypted       = true # you should always do this
  storage_type            = "gp2"
  username                = var.db-username
  vpc_security_group_ids  = ["${aws_security_group.mydb1.id}"]
}
