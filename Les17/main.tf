provider "aws" {
  region = "eu-central-1"
}

variable "env" {
  default = "dev"
}

variable "prod_owner" {
  default = "Anatoliy"
}

variable "dev_owner" {
  default = "Unknown"
}

variable "ec2_size" {
  default = {
    "prod" = "t2.large"
    "dev"  = "t2.micro"
  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}

resource "aws_instance" "super_server" {
  ami                    = "ami-0d4c3eabb9e72650a"
  instance_type          = lookup(var.ec2_size, var.env)
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.dev_owner
  }
}

resource "aws_instance" "server" {
  ami = "ami-0d4c3eabb9e72650a"
  //instance_type = "${var.env == "prod" ? "t2.large" : "t2.micro"}"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.dev_owner
  }
}

resource "aws_instance" "dev_server" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-0d4c3eabb9e72650a"
  instance_type = "t2.micro"

  tags = {
    Name = "Development Server"
  }
}


resource "aws_security_group" "dynamic_sg" {
  name        = "Webserver Security Group"
  description = "Terraformed SG"

  dynamic "ingress" {
    #for_each = var.env == "prod" ? var.allow_port_list["prod"] : var.allow_port_list["dev"]
    for_each = lookup(var.allow_port_list, var.env)
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
