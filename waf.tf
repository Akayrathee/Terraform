resource "aws_wafv2_web_acl" "webacl1" {
  name        = "AWSWAF1"
  description = "AWS WAF 1 creted using terrform for testing."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "webacl1-metric"
    sampled_requests_enabled   = false
  }
}


resource "aws_wafv2_web_acl_association" "webacl1association" {
  resource_arn = aws_alb.WAFalb.arn
  web_acl_arn  = aws_wafv2_web_acl.webacl1.arn
}