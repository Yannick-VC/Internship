terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.8.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}
