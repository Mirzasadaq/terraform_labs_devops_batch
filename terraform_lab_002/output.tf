output "instance_private_ip_addr" {
  value = aws_instance.myfirstvm[*].private_ip
  description = "The Private IP address of the main server"
}

output "instance_public_ip_addr" {
  value = aws_instance.myfirstvm[*].public_ip
  description = "The public IP of the main server"
}