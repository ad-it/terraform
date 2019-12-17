provider "aws" {
  region = "eu-central-1"
  #Europe_Frankfurt
}

provider "aws" {
  region = "us-east-1"
  alias  = "USA"
  #USA_N.Virginia
}

provider "aws" {
  region = "eu-west-1"
  alias  = "IRL"
  #Europe_Ireland
}
#=======================================================

data "aws_ami" "eu_latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "usa_latest_ubuntu" {
  provider    = aws.USA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "irl_latest_ubuntu" {
  provider    = aws.IRL
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

#====================================================

resource "aws_instance" "eu_server" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.eu_latest_ubuntu.id
  tags = {
    Name = "EU Server"
  }

}

resource "aws_instance" "us_server" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.usa_latest_ubuntu.id
  provider      = aws.USA
  tags = {
    Name = "US Server"
  }

}


resource "aws_instance" "irl_server" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.irl_latest_ubuntu.id
  provider      = aws.IRL
  tags = {
    Name = "IRL Server"
  }

}
