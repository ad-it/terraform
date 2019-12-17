provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "test_data" {}
data "aws_caller_identity" "test_caller" {}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.test_data.names[1]
}


output "data_caller_identity" {
  value = data.aws_caller_identity.test_caller.account_id
}
