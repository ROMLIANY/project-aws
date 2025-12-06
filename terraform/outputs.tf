output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.web.id
}

output "rds_endpoint" {
  description = "RDS endpoint (host:port)"
  value       = aws_db_instance.db.address
  sensitive   = true
}

output "db_username" {
  value = aws_db_instance.db.username
}

output "ssm_parameter_name" {
  value = aws_ssm_parameter.db_password.name
}
