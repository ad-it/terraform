region                     = "ca-central-1"
instance_type              = "t2.micro"
enable_detailed_monitoring = false

common_tags = {
  Owner       = "Anatoliy Dadashev tfvars"
  Project     = "Phoenix tfvars"
  CostCenter  = "12345 tfvars"
  Environment = "dev tfvars"
}

allow_ports = ["22"]
