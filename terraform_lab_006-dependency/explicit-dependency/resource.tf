data "aws_ami" "amazon-linux-3" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["137112412989"]
}

resource "aws_s3_bucket" "example" {}

resource "aws_instance" "example_c" {
  ami           = data.aws_ami.amazon-linux-3.id
  instance_type = "t3.micro"

  depends_on = [aws_s3_bucket.example]
}

module "example_sqs_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "5.2.2"

  depends_on = [aws_instance.example_c, aws_s3_bucket.example]
}
