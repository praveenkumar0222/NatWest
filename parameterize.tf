provider "aws" {
  region = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair_name" {
  default = "PRVN"
}

variable "security_group_name" {
  default = "NatWest_Group_security_group"
}

variable "bucket_name" {
  default = "testnatwestgroup"
}


resource "aws_security_group" "natwest_group" {
  name        = var.security_group_name
  description = "Security group for NatWest"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example_instance" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = var.instance_type
  key_name      = aws_key_pair.PRVN.key_name
  security_groups = [aws_security_group.natwest_group.name]

  tags = {
    Name = "example_instance"
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
