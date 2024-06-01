terraform {
  backend "local" {}
  required_version = "1.5.4"
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.44.0"
    }
  }
}
