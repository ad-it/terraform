provider "aws" {
  region = "eu-central-1"
}
resource aws_instance "my_terraform_Linux" {
  ami           = "ami-0cc293023f983ed53"
  instance_type = "t2.small"

  tags = {
    Name    = "My Terraform Linux Server"
    Owner   = "Anatoliy Dadashev"
    Project = "Lessons"
  }
}

