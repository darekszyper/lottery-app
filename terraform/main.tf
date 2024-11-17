provider "aws" {
  region = "eu-central-1"
  version = "~> 4.0"  # Specify AWS provider version
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "mydatabase"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = true

  # Configure the smallest, cheapest instance
  max_allocated_storage = 50
  backup_retention_period = 0
}

output "db_url" {
  value = "jdbc:postgresql://${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/mydatabase"
}

output "db_username" {
  value = aws_db_instance.postgres.username
}

output "db_password" {
  value = aws_db_instance.postgres.password
  sensitive = true
}
#TODO create state backend, for example s3