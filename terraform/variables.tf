variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID to use (Amazon Linux 2 recommended)"
  type        = string
  default     = "ami-0c2b8ca1dad447f8a" # בדוק את ה-AMI באזור שלך והחלף לפי הצורך
}

variable "az_public" {
  type    = string
  default = "us-east-1a"
}

variable "az_private_a" {
  type    = string
  default = "us-east-1b"
}

variable "az_private_b" {
  type    = string
  default = "us-east-1c"
}

variable "db_user" {
  type    = string
  default = "admin"
}

variable "db_name" {
  type    = string
  default = "mydb"
}

variable "db_password_plain" {
  type    = string
  default = "SuperSecret123!"  # מומלץ לשים את זה בקובץ terraform.tfvars או להשתמש ב־Vault/CI secrets
}
