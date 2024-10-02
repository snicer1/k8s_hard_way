# Configure the AWS Provider
provider "aws" {
    region = var.region
    shared_config_files      = ["${var.creds_directory}/config"]
    shared_credentials_files = ["${var.creds_directory}/credentials"]
    profile = "default"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1"
    }
  }
  backend "s3" {
    profile = "default"
    bucket = "terraform-state-file-bucket-1"
    key    = "k8s/terraform.tfstate"
    region = "us-east-1"
  }
}


module "jumpstation" {
    source = "./modules/jumpstation"
    vpc_id = var.vpc_id
    subnet_id = var.subnet_id
    key_name = var.key_name
    ami_id = var.jumpstation_ami_id
    instance_type = var.instance_type
    private_key_path = var.key_path_jumpstations
}
