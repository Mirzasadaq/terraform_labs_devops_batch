provider "aws" {
  region = "ap-south-1"
}

# 1. Generate SSH key pai locally
resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Upload public key to AWS
resource "aws_key_pair" "my_key" {
  key_name   = "terraform-mysql-key"
  public_key = tls_private_key.mykey.public_key_openssh
}

# 3. Security Group (SSH + MySQL)
resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg"
  description = "Allow SSH and MySQL"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. EC2 Instance
resource "aws_instance" "mysql_server" {
  ami                    = "ami-006f82a1d5a27da54"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "Terraform-MySQL-Server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y wget lsb-release gnupg",

      # Add MySQL APT repo
      "wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb",
      "sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.29-1_all.deb",
      "sudo apt-get update -y",

      # Install MySQL Server
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server",

      # Enable + start service
      "sudo systemctl enable mysql",
      "sudo systemctl start mysql",

      # Create user
      "sudo mysql -e \"CREATE USER 'admin'@'%' IDENTIFIED BY 'password123';\"",
      "sudo mysql -e \"GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;\"",
      "sudo mysql -e \"FLUSH PRIVILEGES;\""
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.mykey.private_key_pem # generated key
    host        = self.public_ip
  }
}

# 5. Outputs
output "mysql_server_ip" {
  value = aws_instance.mysql_server.public_ip
}

# Save private key locally (so you can SSH later)
resource "local_file" "private_key_pem" {
  content         = tls_private_key.mykey.private_key_pem
  filename        = "${path.module}/mykey.pem"
  file_permission = "0600"
}