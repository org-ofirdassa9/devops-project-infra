resource "aws_security_group" "alb" {
  name        = "sgr-alb-${var.environment}"
  description = "Allow Web inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP web traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS web traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.vpc_cidr]
  }

  tags = {
    Name = "sgr-alb-${var.environment}"
    Terraform = "True"
  }
}