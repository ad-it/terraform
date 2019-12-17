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
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data = templatefile("user_data.tpl", {
    f_name = "Anatoliy",
    l_name = "Dadashev",
    names  = ["First", "Second", "Third"]
  })

  tags = {
    Name        = "Webserver"
    Terraformed = "true"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "Webserver Security Group"
  description = "Terraformed SG"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "Webserver SG"
    Terraformed = "true"
  }

}
