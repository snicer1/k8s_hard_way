output "jumpstation_public_ip" {
  value = aws_instance.jumpstation.public_ip
}

output "jumpstation_public_key" {
  value = tls_private_key.worker_key.public_key_pem
}