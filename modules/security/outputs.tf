# Nginx Security Group Output
output "nginx_sg_id" {
  description = "ID of the Nginx security group"
  value       = aws_security_group.nginx_sg.id
}

# Backend Security Group Output
output "backend_sg_id" {
  description = "ID of the Backend security group"
  value       = aws_security_group.backend_sg.id
}
