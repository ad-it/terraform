provider "aws" {
  region = "eu-central-1"
}

module "vpc-dev" {
  source = "../modules/aws_network/"
}

module "vpc-uat" {
  source = "../modules/aws_network/"

  env      = "uat"
  vpc_cidr = "10.100.0.0/16"
  public_subnet_cidrs = [
    "10.100.1.0/24",
    "10.100.2.0/24",
    "10.100.3.0/24"
  ]
  private_subnet_cidrs = [
    "10.100.11.0/24",
    "10.100.12.0/24"
  ]
}


#==================

output "dev_public_subnet_ids" {
  value = module.vpc-dev.public_subnet_ids
}

output "uat_public_subnet_ids" {
  value = module.vpc-uat.public_subnet_ids
}


output "dev_private_subnet_ids" {
  value = module.vpc-dev.private_subnet_ids
}

output "uat_private_subnet_ids" {
  value = module.vpc-uat.private_subnet_ids
}
