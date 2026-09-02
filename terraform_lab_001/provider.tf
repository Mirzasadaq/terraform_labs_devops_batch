#To specify a particular version of aws provider we need a terraform block {}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.59.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}