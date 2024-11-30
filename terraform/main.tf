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

# S3 bucket for storing Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "my-unique-terraform-state-bucket-${random_id.suffix.hex}"
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Random suffix to ensure bucket name uniqueness
resource "random_id" "suffix" {
  byte_length = 4
}

terraform {
  backend "s3" {
    bucket = aws_s3_bucket.terraform_state.bucket
    key    = "terraform/state"
    region = "eu-central-1"
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "mydatabase"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = true

  # Configure the cheapest instance
  max_allocated_storage = 50
  backup_retention_period = 0
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
