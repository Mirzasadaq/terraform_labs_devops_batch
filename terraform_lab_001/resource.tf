resource "aws_instance" "myfirstvm" {
  ami           = "ami-006f82a1d5a27da54"
  instance_type = "t3.micro"
  count         = "5"
}

resource "aws_s3_bucket" "myfirstbucket" {
  bucket = "myfirstbucket20260011"
}

resource "aws_vpc" "myfirstnetwork" {
  cidr_block = "10.0.0.0/16"
}