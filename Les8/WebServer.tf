#-------------------
#
#some comment
#
#-------------------

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "webserver" {
  ami                    = "ami-010fae13a16763bb4" #Amazon Linux AWS
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]

  tags = {
    Name        = "Webserver"
    Terraformed = "true"
  }
  depends_on = [aws_instance.db]
}

resource "aws_instance" "db" {
  ami                    = "ami-010fae13a16763bb4" #Amazon Linux AWS
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]

  tags = {
    Name        = "db"
    Terraformed = "true"
  }
}

resource "aws_instance" "app" {
  ami                    = "ami-010fae13a16763bb4" #Amazon Linux AWS
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]

  tags = {
    Name        = "app"
    Terraformed = "true"
  }
  depends_on = [aws_instance.db]
}



resource "aws_security_group" "dynamic_sg" {
  name        = "Webserver Security Group"
  description = "Terraformed SG"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
