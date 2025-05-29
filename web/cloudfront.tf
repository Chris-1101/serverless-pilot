
# █▀▀ █░░ █▀█ █░█ █▀▄ █▀▀ █▀█ █▀█ █▄░█ ▀█▀ 
# █▄▄ █▄▄ █▄█ █▄█ █▄▀ █▀░ █▀▄ █▄█ █░▀█ ░█░ 

# CloudFront Distribution
resource "aws_cloudfront_distribution" "this" {

  enabled = true

  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.this.id

    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    compress = true

    # Viewer
    viewer_protocol_policy = "allow-all"   # HTTP and HTTPs
    allowed_methods        = [ "GET", "HEAD" ]
    cached_methods         = [ "GET", "HEAD" ]
    target_origin_id       = aws_s3_bucket.this.id
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimised.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class         = "PriceClass_100"   # North America & Europe
  http_version        = "http2"
  default_root_object = "index.html"
  is_ipv6_enabled     = true

  wait_for_deployment = false
}

# Origin Access Control
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = aws_s3_bucket.this.id
  description                       = "Restrict access to S3 origin ${ aws_s3_bucket.this.id }"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

