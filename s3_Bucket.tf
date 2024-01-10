provider "aws" {
  region = "us-east-1"  
}


variable "bucket_name" {
  default = "testnatwestgroup"  
}


resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
