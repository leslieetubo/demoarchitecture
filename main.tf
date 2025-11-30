resource "aws_region" "region" {
  name = "us-east-1"
}

resource "aws_availability_zone" "availability_zone" {
  name = "${var.name}" # Required
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(var.tags, {
    Name = "VPC"
  })
}

resource "aws_instance" "ec2_instance" {
  ami = "${var.ami}" # Required
  instance_type = "t2.micro"
  # key_name = ...
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  associate_public_ip_address = false
  tags = merge(var.tags, {
    Name = "EC2 Instance"
  })
}

resource "aws_instance" "ec2_instance" {
  ami = "${var.ami}" # Required
  instance_type = "t2.micro"
  # key_name = ...
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  associate_public_ip_address = false
  tags = merge(var.tags, {
    Name = "EC2 Instance"
  })
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name = "${var.name}" # Required
  min_size = 1
  max_size = 3
  # desired_capacity = ...
  # launch_configuration = ...
  vpc_zone_identifier = "[]"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket}" # Required
  force_destroy = true
  tags = merge(var.tags, {
    Name = "S3 Bucket"
  })
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = "${var.policy}" # Required
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_config" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule = "${var.rule}" # Required
}

resource "aws_lb" "application_load_balancer" {
  name               = "application_load_balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]
  subnets            = [aws_subnet.subnet.id]
}

resource "aws_lb_target_group" "application_load_balancer_tg" {
  name     = "application_load_balancer-tg"
  port     = 80
  protocol = "HTTP"
  # vpc_id = ...
}

resource "aws_lb_listener" "application_load_balancer_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_load_balancer_tg.arn
  }
}


resource "aws_api_gateway_rest_api" "rest_api__apigw_" {
  name = "${var.name}" # Required
  # description = ...
  endpoint_configuration = "EDGE"
}

resource "aws_waf" "waf" {
  name = "${var.name}" # Required
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.availability_zone}" # Required
  map_public_ip_on_launch = false
}

resource "aws_security_group" "security_group" {
  name = "${var.name}" # Required
  # description = ...
  vpc_id = aws_vpc.vpc.id
}