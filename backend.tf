
# Location Where The Statefile Will be Stored For Backup:

terraform {
  backend "s3" {
    bucket         = "week10-zc-terraform"
    key            = "week10/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "state-log"
  }
}
