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
  default = "testnatwestgroup222"
}

# Define the Lambda function code
locals {
  lambda_code = <<LAMBDA
import json
import boto3
import time

def lambda_handler(event, context):
    s3_bucket = event['Records'][0]['s3']['bucket']['name']
    s3_object_key = event['Records'][0]['s3']['object']['key']
    
    cloudwatch_logs = boto3.client('logs')
    
    log_group_name = '/aws/lambda/S3ObjectCreatedLog'
    log_stream_name = 'S3ObjectCreatedLogStream'
    log_message = f"S3 Object Created - Bucket: {s3_bucket}, Object Key: {s3_object_key}"
    
    response = cloudwatch_logs.create_log_group(logGroupName=log_group_name)
    response = cloudwatch_logs.create_log_stream(logGroupName=log_group_name, logStreamName=log_stream_name)
    response = cloudwatch_logs.put_log_events(
        logGroupName=log_group_name,
        logStreamName=log_stream_name,
        logEvents=[
            {
                'timestamp': int(round(time.time() * 1000)),
                'message': log_message
            }
        ]
    )
    
    print(log_message)
LAMBDA
}

# Create the AWS Lambda function
resource "aws_lambda_function" "s3_bucket_event_lambda" {
  filename      = "${path.module}/lambda_function_payload.zip" # To be updated with the actual zip file
  function_name = "S3BucketEventLambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_S3_bucket_event.lambda_handler"
  runtime       = "python3.8"
}

# Create an IAM role for Lambda execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach necessary policies to the IAM role
resource "aws_iam_policy_attachment" "lambda_logs_policy_attachment" {
  name       = "lambda_logs_policy_attachment"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create a trigger for the Lambda function (S3 bucket event)
resource "aws_lambda_permission" "s3_bucket_event_lambda_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_bucket_event_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.website_bucket.arn
}

# Create an EC2 instance and necessary security groups
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
  ami                = "ami-0005e0cfe09cc9050"
  instance_type      = var.instance_type
  key_name           = "PRVN"
  security_groups    = [aws_security_group.natwest_group.name]

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

# Prepare the Lambda function code and create a zip file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code"
  output_path = "${path.module}/lambda_function_payload.zip"
}

# Output the S3 bucket name for reference
output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}
