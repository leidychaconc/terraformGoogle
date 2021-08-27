variable "tier" { default = "db-f1-micro" }
variable "db_region" { default = "us-central1" }
variable "disk_size" { default = "20" }
variable "database_version" { default = "POSTGRES_11" }
variable "user_name" { default = "odoo" }
variable "user_password" { default = "Patito123." }
variable "replication_type"  { default = "SYNCHRONOUS" }
variable "activation_policy" { default = "always" }