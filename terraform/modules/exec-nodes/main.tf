resource "aws_instance" "exec_node" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.exec_node_sg.id]
  subnet_id              = var.subnet_id

  user_data = base64encode(file("./scripts/workernode_startup.sh"))

  tags = {
    Name = "exec-node-${count.index + 1}"
  }
}

resource "aws_security_group" "exec_node_sg" {
  name        = "exec-node-sg"
  description = "Security group for exec nodes"
  vpc_id      = var.vpc_id

  # Add necessary ingress and egress rules here
  # For example:
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
}
