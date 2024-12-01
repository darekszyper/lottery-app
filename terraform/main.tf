terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-154335"
    key     = "terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

resource "aws_db_instance" "postgres" {
  allocated_storage   = 20
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  db_name             = "mydatabase"
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
  publicly_accessible = true

  # Configure the smallest, cheapest instance
  max_allocated_storage   = 50
  backup_retention_period = 0
}

# Output database connection details
output "db_url" {
  value = format("jdbc:postgresql://%s:%s/mydatabase",
    aws_db_instance.postgres.address,
    aws_db_instance.postgres.port
  )
}

# Non-sensitive username output
output "db_username" {
  value = var.db_username
}