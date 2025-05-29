
# █▀▄ ▄▀█ ▀█▀ ▄▀█   █▀ █▀█ █░█ █▀█ █▀▀ █▀▀ █▀ 
# █▄▀ █▀█ ░█░ █▀█   ▄█ █▄█ █▄█ █▀▄ █▄▄ ██▄ ▄█ 

# STS Caller Identity
data "aws_caller_identity" "current" {}

# Main VPC
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [ "main-vpc" ]
  }
}

# App Subnet A
data "aws_subnet" "app_a" {
  filter {
    name   = "tag:Name"
    values = [ "main-app-a" ]
  }
}

# App Subnet B
data "aws_subnet" "app_b" {
  filter {
    name   = "tag:Name"
    values = [ "main-app-b" ]
  }
}

# App Subnet C
data "aws_subnet" "app_c" {
  filter {
    name   = "tag:Name"
    values = [ "main-app-c" ]
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.main.id
  name   = "default"
}
