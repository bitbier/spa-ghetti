provider "aws" {
  region  = "us-east-1"
  profile = "${var.aws_profile}"
}

#
# Create the S3 bucket that will host our application
#

resource "aws_s3_bucket" "main" {
  bucket_prefix       = "${var.app_name}"
  acl                 = "private"
  force_destroy       = true
  acceleration_status = "Enabled"
}

#
# Give cloudfront access to our bucket
#

resource "aws_cloudfront_origin_access_identity" "main" {
  comment = "Created for ${var.app_name}"
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.main.arn}",
      "${aws_s3_bucket.main.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.main.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = "${aws_s3_bucket.main.id}"
  policy = "${data.aws_iam_policy_document.s3.json}"
}

#
# Create our cloudfront distribution
#

resource "aws_cloudfront_distribution" "main" {
  enabled         = true
  http_version    = "http2"
  price_class     = "PriceClass_All"
  is_ipv6_enabled = true

  origin {
    origin_id   = "s3-origin"
    domain_name = "${aws_s3_bucket.main.bucket_domain_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
