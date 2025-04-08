provider "aws" {
  region  = "ap-south-1"
}
resource "aws_s3_bucket" "remotes3" {
  bucket = "my-statefile-remote-bucket"

  lifecycle {
    prevent_destroy = false
  }

}

resource "aws_s3_bucket_versioning" "remotes3versioning" {
  bucket = aws_s3_bucket.remotes3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "remotes3encryption" {
  bucket = aws_s3_bucket.remotes3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "statelockdb" {
    name = "my-statefile-lock-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
    name = "LockID"
    type = "S"
  }
}