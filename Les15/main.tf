provider "aws" {
  region = "eu-central-1"
}


resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform Start : $(date) >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 google.com"
  }
}
