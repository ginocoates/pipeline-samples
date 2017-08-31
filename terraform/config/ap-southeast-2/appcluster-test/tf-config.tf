terraform {
  backend "s3" {
    bucket = "yourbucket-terraform"
    key    = "appcluster-test/terraform.tfstate"
    region = "ap-southeast-2"
  }
}
