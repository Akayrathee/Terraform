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