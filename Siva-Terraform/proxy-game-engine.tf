locals {
# enabled = true
}

resource "aws_db_proxy" "game_engine" {
#  count = local.enabled ? 1 : 0

  name                   = "${var.env}-cf-game-engine-proxy"
  debug_logging          = var.debug_logging
  engine_family          = var.engine_family
  idle_client_timeout    = var.idle_client_timeout
  require_tls            = var.require_tls
  role_arn               = aws_iam_role.db_proxy_role.arn
  vpc_security_group_ids = ["${aws_security_group.mydb1.id}"]
  vpc_subnet_ids         = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id, aws_subnet.pubsub3.id]
  depends_on = ["resource.aws_secretsmanager_secret.password","resource.aws_db_instance.mydb1", "resource.aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_db_proxy"] 
  auth {
    auth_scheme = "SECRETS"
    description = "using secret manager"
    iam_auth    = "DISABLED"
    secret_arn  = var.proxy_secret_arn
  }
  #dynamic "auth" {
   # for_each = var.auth

    #content {
     # auth_scheme = auth.value.auth_scheme
      #description = auth.value.description
      #iam_auth    = auth.value.iam_auth
      #secret_arn  = auth.value.secret_arn
    #}
  #}

  #tags = module.this.tags

  timeouts {
    create = var.proxy_create_timeout
    update = var.proxy_update_timeout
    delete = var.proxy_delete_timeout
  }
}

resource "aws_db_proxy_default_target_group" "game_engine" {
#  count = local.enabled ? 1 : 0

  db_proxy_name = join("", aws_db_proxy.game_engine[*].name)

  dynamic "connection_pool_config" {
    for_each = (
      var.connection_borrow_timeout != null || var.init_query != null || var.max_connections_percent_game_engine != null ||
      var.max_idle_connections_percent != null || var.session_pinning_filters != null
    ) ? ["true"] : []

    content {
      connection_borrow_timeout    = var.connection_borrow_timeout
      init_query                   = var.init_query
      max_connections_percent      = var.max_connections_percent_game_engine
      max_idle_connections_percent = var.max_idle_connections_percent
      session_pinning_filters      = var.session_pinning_filters
    }
  }
}

resource "aws_db_proxy_target" "game_engine" {
#  count = local.enabled ? 1 : 0

  db_instance_identifier = var.db_instance_identifier
  #db_cluster_identifier  = var.db_cluster_identifier
  db_proxy_name          = join("", aws_db_proxy.game_engine[*].name)
  target_group_name      = join("", aws_db_proxy_default_target_group.game_engine[*].name)
}
