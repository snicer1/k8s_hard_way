output "instance_ids" {
  description = "IDs of the created instances"
  value       = aws_instance.exec_node[*].id
}

output "private_ips" {
  description = "Private IPs of the created instances"
  value       = aws_instance.exec_node[*].private_ip
}
