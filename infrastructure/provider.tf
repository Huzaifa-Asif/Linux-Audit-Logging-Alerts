terraform {
  required_version = ">= 1.5.2, <= 1.6.1"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.54.0"
    }
  }
}