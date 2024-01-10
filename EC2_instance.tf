provider "aws" {
  region = "us-east-1" 
}


# resource "aws_key_pair" "example_keypair" {
#   key_name   = "example_keypair"
#   public_key = file("~/.ssh/id_rsa.pub") 
# }

resource "aws_key_pair" "PRVN" {
  key_name   = "PRVN"
  public_key = file("/home/ec2-user/PRVN.pem")
}



resource "aws_security_group" "natwest_group" {
  name        = "NatWest_Group_security_group"
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
  instance_type = "t2.micro"
  key_name      = aws_key_pair.PRVN.key_name
  security_groups = [aws_security_group.natwest_group.name]

  tags = {
    Name = "example_instance"
  }
}