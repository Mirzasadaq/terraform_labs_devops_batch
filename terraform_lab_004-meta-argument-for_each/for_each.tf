variable "instances" {
  type = map(string)
  default = {
    jenkins = "t3.micro"
    nexus = "t3.small"
    sonarqube = "c7i-flex.large"
  }
}


resource "aws_instance" "ec2" {
  for_each = var.instances

  ami = "ami-006f82a1d5a27da54"
  instance_type = each.value

  tags = {
    Name = "ec2-${each.key}"
    Env = each.key
  }
}