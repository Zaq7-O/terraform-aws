resource "aws_security_group" "tnc_sg" {
  vpc_id = aws_vpc.tnc_vpc.id
  name   = "tnc_sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.112.66.25/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tnc_sg"
  }
}

resource "tls_private_key" "tnc_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "tnc_key" {
  key_name   = "tnc_key"
  public_key = tls_private_key.tnc_key.public_key_openssh

  tags = {
    Name = "tnc_key"
  }
}
resource "aws_secretsmanager_secret" "tnc_key" {
  name = "tnc_key"
}

resource "aws_secretsmanager_secret_version" "tnc_key" {
  secret_id     = aws_secretsmanager_secret.tnc_key.id
  secret_string = tls_private_key.tnc_key.private_key_pem
}

resource "aws_instance" "tnc_instance" {
    ami             = "ami-0cf2b4e024cdb6960"
    instance_type   = "t3.micro"
    subnet_id       = aws_subnet.tnc_subnet2.id
    vpc_security_group_ids  = [aws_security_group.tnc_sg.id]
    key_name        =  aws_key_pair.tnc_key.key_name
    associate_public_ip_address = true

    tags = {
        Name = "tnc_instance"
}

    user_data = <<-EOF
            #!/bin/bash
            sudo apt-get update
            sudo apt-get install -y apache2
            sudo systemctl start apache2
            sudo systemctl enable apache2
            sudo echo '<html><body><h1>Hello, World!</h1></body></html>' > /var/www/html/index.html
            EOF
}
