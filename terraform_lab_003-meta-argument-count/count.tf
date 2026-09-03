# variable "instance_count" {
#   type = number
#   default = 3
# }

# resource "aws_instance" "ec2" {
#   count = var.instance_count

#   ami = ""
#   instance_type = "t3.micro"

#   tags = {
#     Name = "ec2-${count.index}"
#   }
# }

#if you want to create multiple identical resources , shall we use the same name 

resource "aws_instance" "ec2" {
  count = 2

  ami = "ami-006f82a1d5a27da54"
  instance_type = "t3.micro"

  tags = {
    Name = "ec2server${count.index}"
  }
}