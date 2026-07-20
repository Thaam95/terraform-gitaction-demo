variable "aws_region" {
  description = "AWS region used by the POC."
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Prefix used for resource names and tags."
  type        = string
  default     = "cap-poc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "allowed_ingress_cidr" {
  description = "CIDR allowed to reach demo ports in the security group. Keep restrictive in real use."
  type        = string
  default     = "10.0.0.0/8"
}
