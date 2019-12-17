provider "aws" {
  region = "eu-central-1"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  some_var  = "${var.environment}-${var.project_name}"
  some_var2 = join(",", data.aws_availability_zones.available.names)
  region    = data.aws_region.current.description
  location  = "In ${local.region} AZs are ${local.some_var2}"
}
resource "aws_eip" "my_static_ip" {
  tags = {
    Name     = "Static IP"
    Owner    = var.owner
    Project  = local.some_var
    AZ       = local.some_var2
    location = local.location
  }
}
