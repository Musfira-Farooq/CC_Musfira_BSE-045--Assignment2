variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix for naming"
  type        = string
}

variable "my_ip" {
  description = "Your public IP address in CIDR format (e.g., 1.2.3.4/32)"
  type        = string
}
