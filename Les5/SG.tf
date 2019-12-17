#-------------------
#
#some comment
#
#-------------------

provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "dynamic_sg" {
  name        = "Webserver Security Group"
  description = "Terraformed SG"

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "9092"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "Dynamic scaleway_security_group"
    Terraformed = "true"
  }

}
