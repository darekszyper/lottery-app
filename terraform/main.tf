provider "aws" {
  region  = "eu-central-1"
  version = "~> 4.0"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "terraform/state"
    region = "eu-central-1"
  }
}

# PostgreSQL RDS Instance (simple and cheapest)
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "mydatabase"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = true  # Consider changing to false for private access
  max_allocated_storage = 50
  backup_retention_period = 0  # No backups to save costs
}

# Output database connection details
output "db_url" {
  value = "jdbc:postgresql://${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/mydatabase"
}

output "db_username" {
  value = aws_db_instance.postgres.username
}

output "db_password" {
  value     = aws_db_instance.postgres.password
  sensitive = true
}
