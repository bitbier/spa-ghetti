output "bucket_name" {
  value = "${aws_s3_bucket.main.id}"
}

output "cloudfront_id" {
  value = "${aws_cloudfront_distribution.main.id}"
}

output "cloudfront_domain" {
  value = "${aws_cloudfront_distribution.main.domain_name}"
}
