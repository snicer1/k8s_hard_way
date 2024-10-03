# Security Group
resource "aws_security_group" "jumpstation_sg" {
  name        = "jumpstation-sg"
  description = "Security group for jumpstation"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "jumpstation-sg"
  })
}

# EC2 Instance
resource "aws_instance" "jumpstation" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.jumpstation_sg.id]

  tags = merge(var.tags, {
    Name = "Jumpstation"
  })

  user_data = base64encode(file("./scripts/jumpstation_startup.sh"))
}

resource "tls_private_key" "worker_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "null_resource" "copy_key_to_jumpstation" {
  depends_on = [aws_instance.jumpstation]

  provisioner "file" {
    content     = tls_private_key.worker_key.private_key_pem
    destination = "/home/ubuntu/.ssh/worker_key.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = aws_instance.jumpstation.public_ip
    }
  }
}