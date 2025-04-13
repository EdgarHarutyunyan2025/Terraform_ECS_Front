data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

terraform {
  backend "s3" {
    bucket = "task-project-01"
    key    = "front/terraform.tfstate"
    region = "eu-central-1"
  }
}


data "terraform_remote_state" "back" {
  backend = "s3"

  config = {
    bucket = "task-project-01"
    key    = "back/terraform.tfstate"
    region = "eu-central-1"
  }
}
