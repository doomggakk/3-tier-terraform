# --------------------------------------------------------------
# RDS
# --------------------------------------------------------------
module "rds" {

  source  = "terraform-aws-modules/rds/aws"

  identifier = "rds-pg-01"

  engine                     = "postgres"
  engine_version             = "13.5"
  family                     = "postgres13" # DB parameter group
  major_engine_version       = "13"         # DB option group
  instance_class             = "db.t3.medium"
  auto_minor_version_upgrade = false

  allocated_storage = 100
  storage_encrypted = false
  #max_allocated_storage = 100

  db_name                = "rds"
  username               = "admin"
  password               = var.rds_master_password
  create_random_password = false
  port                   = 5543

  multi_az                        = true   # multi-AZ 허용
  create_db_subnet_group          = true
  db_subnet_group_name            = "sng-private"
  db_subnet_group_use_name_prefix = false
  db_subnet_group_description     = "sng-private"
  db_subnet_group_tags            = { Name = "sng-private" }
  subnet_ids                      = module.vpc.private_subnets

  create_db_parameter_group       = true
  parameter_group_name            = "rds-pg-01"
  parameter_group_use_name_prefix = false
  parameter_group_description     = "rds-pg-01"
  parameters = [
    {
      name  = "log_min_duration_statement"
      value = "20000"
    },
    {
      name         = "pg_stat_statements.max"
      value        = "1000"
      apply_method = "pending-reboot"
    },
    {
      name  = "timezone"
      value = "Asia/Seoul"
    },
    {
      name         = "shared_preload_libraries"
      value        = "pg_stat_statements,pg_hint_plan"
      apply_method = "pending-reboot"
    },
    {
      name         = "track_activity_query_size"
      value        = "50000"
      apply_method = "pending-reboot"
    }
  ]
  vpc_security_group_ids = [module.rds-pg-sg.security_group_id]

  maintenance_window                     = "sun:21:00-sun:21:30"
  backup_window                          = "20:00-20:30"
  enabled_cloudwatch_logs_exports        = ["postgresql", "upgrade"]
  create_cloudwatch_log_group            = true
  cloudwatch_log_group_retention_in_days = 0
  copy_tags_to_snapshot                  = true

  backup_retention_period = 8
  skip_final_snapshot     = true
  deletion_protection     = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = false
  monitoring_role_arn                   = "arn:aws:iam::<account-id>:role/rds-monitoring-role"

  tags = {
    Name    = "rds-pg-01"
    Managed = "Terraform"
  }
}

output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}


# --------------------------------------------------------------
# Security Groups RDS
# --------------------------------------------------------------
module "rds-pg-sg" {
  
  source  = "./module/security-group"
  
  name        = "rds-pg-db-sg"
  description = "rds-pg-db-sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Managed = "Terraform"
    Name    = "rds-pg-db-sg"
  }

  security_group_rules = {
    ingress = {
      type        = "ingress"
      from_port   = 5543
      to_port     = 5543
      protocol    = "tcp"
      description = ""
      cidr_blocks = [< 허용 cidr >]
    },
    egress_tcp = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }


}

