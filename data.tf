# --------------------------------------------------------------
# ACM 
# --------------------------------------------------------------
data "aws_acm_certificate" "certificate" {
  domain      = "*.example.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
