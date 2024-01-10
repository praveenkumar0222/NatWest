provider "aws" {
  region = "us-east-1"  
}


variable "bucket_name" {
  default = "test_natwest_group"  
}


resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"  

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
