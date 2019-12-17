provider "aws" {
  region = "eu-central-1"
}


terraform {
  backend "s3" {
    bucket = "tf-remote-state-adit"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-central-1"
  }
}
#=====================================================================

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tf-remote-state-adit"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#=====================================================================

resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  user_data              = <<EOF
#!/bin/bash
echo "-----------GOGOGOGO-------------------"
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<html><body bgcolor=black><center><h2><p><font color=red>Terraform with RemoteState</h2></center></body></html>" > /var/www/html/index.html
echo "<h2> WebServer with IP: $myip </h2><br>Build by Terraform with RemoteState!" > /var/www/html/index.html
service httpd start
chkconfig httpd on
echo "-----------FINISH-----------"
EOF

  tags = {
    Name = "Webserver"
  }
}

resource "aws_security_group" "webserver" {
  name   = "Webserver sec group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name  = "webserver-sg"
    Owner = "Anatoliy Dadashev"
  }
}

output "webserver_sg_id" {
  value = aws_security_group.webserver.id
}

output "webserver_public_ip" {
  value = aws_instance.webserver.public_ip
}
