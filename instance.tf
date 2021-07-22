resource "aws_instance" "Uturn-instance-1" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.Uturn-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.Uturn-sg.id]

}

resource "aws_instance" "Uturn-instance-2" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.Uturn-public-2.id

  # the security group
  vpc_security_group_ids = [aws_security_group.Uturn-sg.id]

}


#resource "aws_lb" "Uturn-lb" {
#  name               = "Uturn-lb-tf"
#  internal           = false
#  load_balancer_type = "application"
#  security_groups    = [aws_security_group.lb_sg.id]
#  subnets            = aws_subnet.Uturn-public-*.id

#  enable_deletion_protection = true
#}



resource "aws_lb" "Uturn-elb" {
  name               = "Uturn-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Uturn-sg.id]
  subnets            = [aws_subnet.Uturn-public-1.id, aws_subnet.Uturn-public-2.id]
}

resource "aws_lb_target_group" "Uturn-tg" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Uturn-vpc.id
}

resource "aws_lb_target_group_attachment" "Uturn-tg1" {
  target_group_arn = aws_lb_target_group.Uturn-tg.arn
  target_id        = aws_instance.Uturn-instance-1.id
  port             = 80

  depends_on = [
    aws_instance.Uturn-instance-1,
  ]
}

resource "aws_lb_target_group_attachment" "Uturn-tg2" {
  target_group_arn = aws_lb_target_group.Uturn-tg.arn
  target_id        = aws_instance.Uturn-instance-2.id
  port             = 80

  depends_on = [
    aws_instance.Uturn-instance-2,
  ]
}

resource "aws_lb_listener" "Uturn-tg" {
  load_balancer_arn = aws_lb.Uturn-elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Uturn-tg.arn
  }
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

resource "aws_dynamodb_table" "us-east-2" {
  provider = aws.us-east-2

  hash_key         = "myAttribute"
  name             = "myTable"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = "myAttribute"
    type = "S"
  }
}








