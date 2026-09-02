terraform {
  backend "s3" {
    bucket       = "terraform-demo-backend001-704134885587-ap-south-1-an"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}
