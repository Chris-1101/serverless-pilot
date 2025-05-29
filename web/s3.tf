
# █▀ █ █▀▄▀█ █▀█ █░░ █▀▀   █▀ ▀█▀ █▀█ █▀█ ▄▀█ █▀▀ █▀▀   █▀ █▀▀ █▀█ █░█ █ █▀▀ █▀▀ 
# ▄█ █ █░▀░█ █▀▀ █▄▄ ██▄   ▄█ ░█░ █▄█ █▀▄ █▀█ █▄█ ██▄   ▄█ ██▄ █▀▄ ▀▄▀ █ █▄▄ ██▄ 

# S3 bucket
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
}

# Public access block
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Default Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Static Website
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Bucket policy
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = templatefile("json/bucket-oac-policy.json", {
    s3_bucket_arn = aws_s3_bucket.this.arn
    cf_distro_arn = aws_cloudfront_distribution.this.arn
  })
}

