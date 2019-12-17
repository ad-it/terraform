provider "aws" {
  region = "eu-central-1"
}

variable "aws_users" {
  description = "List of IAM users to create"
  default     = ["vasya", "petya", "lena", "dima", "kirill", "vova"]
}

resource "aws_iam_user" "user1" {
  name = "onegin"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

output "iam_users_output" {
  value = aws_iam_user.users
}



output "iam_output_ids" {
  value = aws_iam_user.users[*].id
}


output "iam_output_custom" {
  value = [
    for i in aws_iam_user.users :
    "Username: ${i.name} has ARN ${i.arn}"
  ]
}

output "created_iam_users_map" {
  value = {
    for i in aws_iam_user.users :
    i.unique_id => i.id //
  }
}

output "iam_users_special_output" {
  value = [
    for i in aws_iam_user.users :
    i.name
    if length(i.name) == 4
  ]
}

#=======================================================


resource "aws_instance" "server" {
  ami           = "ami-0d4c3eabb9e72650a"
  instance_type = "t2.micro"
  count         = 3
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}


output "aws_instances_output" {
  value = {
    for i in aws_instance.server :
    i.arn => i.public_ip
  }
}
