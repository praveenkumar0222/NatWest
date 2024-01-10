#!/bin/bash
ssh -i /home/ubuntu/PRVN.pem ec2-user@54.224.66.194
sudo yum update -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx