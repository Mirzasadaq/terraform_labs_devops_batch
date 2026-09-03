provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias = "us"
  region = "us-east-1"
}

resource "aws_instance" "india_ec2" {

  ami = "ami-006f82a1d5a27da54"
  instance_type = "t3.micro"

  tags = {
    Name = "india-instance"
  }
}

resource "aws_instance" "us_ec2" {
  provider = aws.us
  ami = "ami-0f8a61b66d1accaee"
  instance_type = "t3.micro"

  tags = {
    Name = "us-instance"
  }
}