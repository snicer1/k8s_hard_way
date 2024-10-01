# variables.tf

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"  # You can set a default value or remove this line if you want to always specify it
}

variable "creds_directory" {
  description = "The directory path where AWS credentials are stored"
  type        = string
  default     = "~/.aws"  # Default path for AWS credentials, adjust if necessary
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "jumpstation_ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}
