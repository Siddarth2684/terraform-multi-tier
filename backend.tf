terraform {
  backend "s3" {
    bucket         = "siddarth-tfstate-bucket"
    key            = "multi-tier/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}