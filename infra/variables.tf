variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-west-2"
}

variable "ssh_key_name" {
  description = "Name of the existing AWS keypair to use for SSH"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the Minecraft server"
  type        = string
  default     = "t3.medium"
}