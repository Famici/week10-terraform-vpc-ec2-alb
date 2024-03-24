## All the informations about the Terraform Version --->
## And the provider "AWS" used to run our code: ##

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }
}

provider "aws" {

  region = "us-east-1"
}
