#ENV name
variable "env" {
 type = string
 default = "dev04"
}

#VPC details
variable "vpccidr" {
  default = "10.10.0.0/16"
}
variable "pubsub1cidr" {
  default = "10.10.0.0/24"
}
variable "pubsub2cidr" {
  default = "10.10.1.0/24"
}
variable "pubsub3cidr" {
  default = "10.10.2.0/24"
}
variable "prisub1cidr" {
  default = "10.10.3.0/24"
}
variable "prisub2cidr" {
  default = "10.10.4.0/24"
}
variable "prisub3cidr" {
  default = "10.10.5.0/24"
}

#DB details
variable "db-username" {
  type        = string
  default     = "cfmaindb"
  description = "user name of postgres DB"
}
variable "db_size" {
  type        = string
  default     = "20"
  description = "postgres DB size"
}
variable "engine_version" {
  type        = string
  default     = "13.7"
  description = "engine version of postgres DB"
}
variable "instance_class" {
  type        = string
  default     = "db.t3.small"
  description = "instance class of postgres DB"
}
variable "db_name" {
  type        = string
  default     = "cfmain"
  description = "DB name of postgres"
}


#ALB details for backend servers (Nakama service included)
variable "application_alb" {
 type         = string
 default      = "cf-application-alb"
 description  = "alb for application server"
}
variable "certificate_arn" {
  type        = string
  default     = "arn:aws:acm:ap-south-1:876529261348:certificate/893743f6-2af1-44de-b02f-fd012a99ad35"
  description = "ACM certificate for application alb listner"
}

#ASG details for Admin, Game-engine and Blockchain services (Nakama service included)
variable "admin_ec2_name" {
  type        = string
  default     = "cf-admin"
  description = "ec2 name for admin serivce"
}
variable "block_chain_ec2_name" {
  type        = string
  default     = "cf-blockchain"
  description = "ec2 name for blockchain service"
}
variable "game_engine_ec2_name" {
  type        = string
  default     = "cf-game-engine"
  description = "ec2 name for game-engine service"
}
variable "min_size" {
  type        = string
  default     = "1"
  description = "min size of ASG ec2 instance"
}
variable "max_size" {
  type        = string
  default     = "3"
  description = "max size of ASG ec2 instance"
}
variable "desired_capacity" {
  type        = string
  default     = "1"
  description = "desired capacity of ASG ec2 instance"
}
variable "health_check_type" {
  type        = string
  default     = ""
  description = "description"
}
variable "ami_id" {
  type        = string
  default     = "ami-09a22e9d84683f96f"
  description = "AMI id to create an ASG ec2 instances"
}
variable "instance_type" {
  type        = string
  default     = "t2.medium"
  description = "Instance type of ASG ec2 instances"
}
variable "volume_size" {
  type        = string
  default     = "30"
  description = "volume size of ASG ec2 instances"
}
variable "app_instance_profile_arn" {
  type        = string
  default     = "arn:aws:iam::876529261348:instance-profile/terraform-service-role"
  description = "IAM role to attach ASG ec2 instances"
}
variable "key_name" {
  type        = string
  default     = "bastion"
  description = "ssh key name of ASG ec2 instances"
}
variable "cpu_high_asg_cooldown_period" {
 type         = string
 default      = "300"
}
variable "cpu_low_asg_cooldown_period" {
 type         = string
 default      = "100"
}

#Lambda details for application, compute, and profile services
variable "application-lambda-name" {
  default     = "cf-application"
  description = "application service name for to create a lambda" 
}
variable "application-lambda-name-s3" {
  default     = "build-lambda-s3"
  description = "s3 bucket name of lambda builds"
}
variable "application-lambda-name-s3-path" {
  default     = "dev04/application-service/V-1.1.18-B0421/lambda-package.zip"
  description = "s3 path to keep the artifact for application lambda service"
}

variable "compute-lambda-name" {
  default     = "cf-compute"
  description = "compute service name for to create a lambda"
}
variable "compute-lambda-name-s3" {
  default     = "build-lambda-s3"
  description = "s3 bucket name of lambda builds"
}
variable "compute-lambda-name-s3-path" {
  default     = "dev04/compute-service/V-1.1.18-B0429/lambda-package.zip"
  description = "s3 path to keep the artifact for compute lambda service"
}

variable "profile-lambda-name" {
  default     = "cf-profile"
  description = "profile service name for to create a lambda"
}
variable "cf-profile-lambda-name-s3" {
  default     = "build-lambda-s3"
  description = "s3 bucket name of lambda builds"
}
variable "cf-profile-lambda-name-s3-path" {
  default     = "dev04/profile-service/V-1.1.19-B0452/lambda-package.zip"
  description = "s3 path to keep the artifact for profile lambda service"
}

#S3 bucket for admin site and customer site details
variable "s3_admin_bucket_name" {
 type         = string
 default      = "cf-admin"
}
variable "s3_customer_bucket_name" {
 type         = string
 default      = "cf-customer"
}

variable "admin_domain_name" {
 type         = string
 default      = "dev04-admin.devcoinfantasy.co.in"
}
variable "customer_domain_name" {
 type         = string
 default      = "dev04-customer.devcoinfantasy.co.in"
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
}

#CloudFront details of admin and customer site
variable "cert_cloud" {
 type         = string
 default      = "arn:aws:acm:us-east-1:876529261348:certificate/f268fb25-56a8-49b3-9e31-59e153f037d2"
}

#proxy details
variable "proxy_secret_arn" {
  type        = string
  default     = "arn:aws:secretsmanager:ap-south-1:876529261348:secret:dev04-proxy1-49ewAY"
  description = "secret "
}

variable "debug_logging" {
  type        = bool
  default     = false
  description = "Whether the proxy includes detailed information about SQL statements in its logs"
}

variable "engine_family" {
  type        = string
  default     = "POSTGRESQL"
  description = "The kinds of databases that the proxy can connect to. This value determines which database network protocol the proxy recognizes when it interprets network traffic to and from the database. The engine family applies to MySQL and PostgreSQL for both RDS and Aurora. Valid values are MYSQL and POSTGRESQL"
}

variable "idle_client_timeout" {
  type        = number
  default     = 1800
  description = "The number of seconds that a connection to the proxy can be inactive before the proxy disconnects it"
}

variable "require_tls" {
  type        = bool
  default     = false
  description = "A Boolean parameter that specifies whether Transport Layer Security (TLS) encryption is required for connections to the proxy. By enabling this setting, you can enforce encrypted TLS connections to the proxy"
}

variable "db_instance_identifier" {
  type        = string
  default     = "dev04-cfmaindb"
  description = "DB instance identifier. Either `db_instance_identifier` or `db_cluster_identifier` should be specified and both should not be specified together"
}

variable "db_cluster_identifier" {
  type        = string
  default     = ""
  description = "DB cluster identifier. Either `db_instance_identifier` or `db_cluster_identifier` should be specified and both should not be specified together"
}

variable "connection_borrow_timeout" {
  type        = number
  default     = 120
  description = "The number of seconds for a proxy to wait for a connection to become available in the connection pool. Only applies when the proxy has opened its maximum number of connections and all connections are busy with client sessions"
}

variable "init_query" {
  type        = string
  default     = null
  description = "One or more SQL statements for the proxy to run when opening each new database connection"
}

variable "max_connections_percent_admin" {
  type        = number
  default     = 5
  description = "The maximum size of the connection pool for each target in a target group"
}


variable "max_connections_percent_application" {
  type        = number
  default     = 40
  description = "The maximum size of the connection pool for each target in a target group"
}

variable "max_connections_percent_blockchain" {
  type        = number
  default     = 5
  description = "The maximum size of the connection pool for each target in a target group"
}

variable "max_connections_percent_compute" {
  type        = number
  default     = 20
  description = "The maximum size of the connection pool for each target in a target group"
}

variable "max_connections_percent_game_engine" {
  type        = number
  default     = 20
  description = "The maximum size of the connection pool for each target in a target group"
}

variable "max_connections_percent_profile" {
  type        = number
  default     = 5
  description = "The maximum size of the connection pool for each target in a target group"
}


variable "max_idle_connections_percent" {
  type        = number
  default     = 2
  description = "Controls how actively the proxy closes idle database connections in the connection pool. A high value enables the proxy to leave a high percentage of idle connections open. A low value causes the proxy to close idle client connections and return the underlying database connections to the connection pool"
}

variable "session_pinning_filters" {
  type        = list(string)
  default     = null
  description = "Each item in the list represents a class of SQL operations that normally cause all later statements in a session using a proxy to be pinned to the same underlying database connection"
}

variable "iam_role_attributes" {
  type        = list(string)
  default     = null
  description = "Additional attributes to add to the ID of the IAM role that the proxy uses to access secrets in AWS Secrets Manager"
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "The ARN or Id of the AWS KMS customer master key (CMK) to encrypt the secret values in the versions stored in secrets. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default CMK (the one named `aws/secretsmanager`)"
}

variable "proxy_create_timeout" {
  type        = string
  default     = "30m"
  description = "Proxy creation timeout"
}

variable "proxy_update_timeout" {
  type        = string
  default     = "30m"
  description = "Proxy update timeout"
}
variable "proxy_delete_timeout" {
  type        = string
  default     = "60m"
  description = "Proxy delete timeout"
}


