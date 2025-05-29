
# █▀▄ ▄▀█ ▀█▀ ▄▀█   █▀ █▀█ █░█ █▀█ █▀▀ █▀▀ █▀ 
# █▄▀ █▀█ ░█░ █▀█   ▄█ █▄█ █▄█ █▀▄ █▄▄ ██▄ ▄█ 

data "aws_cloudfront_cache_policy" "caching_optimised" {
  name = "Managed-CachingOptimized"
}

