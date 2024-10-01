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

  user_data = base64encode(file("../templates/jumpstation_startup_script.sh"))
}


resource "null_resource" "generate_key_pair" {
  depends_on = [aws_instance.jump_station]

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -t rsa -b 2048 -f ~/.ssh/exec_node_key -N ''",
      "echo 'Key pair generated on jump station'",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"  # or the appropriate user for your AMI
      private_key = file("path/to/your/existing-key-pair.pem")
      host        = aws_instance.jump_station.public_ip
    }
  }
}

data "external" "public_key" {
  depends_on = [null_resource.generate_key_pair]

  program = ["ssh", 
    "-i", "path/to/your/existing-key-pair.pem",
    "-o", "StrictHostKeyChecking=no",
    "ec2-user@${aws_instance.jump_station.public_ip}",
    "cat ~/.ssh/exec_node_key.pub"
  ]
}