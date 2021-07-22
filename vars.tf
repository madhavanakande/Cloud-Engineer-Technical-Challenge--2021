variable "AWS_REGION" {
  default = "us-east-2"
}

variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-2 = "ami-0233c2d874b811deb"
  }
}

