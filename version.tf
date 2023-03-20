terraform {
  required_providers {

    aws = {
      version = ">= 4.34"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"

  assume_role {
    role_arn = "<assume role arn>"
  }
}


