resource "aws_wafv2_web_acl" "webacl1" {
  name        = "Domo-Demo1-WAF"
  description = "WAF used on Demo1 ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

# For evry rule you need to add another rule block
  rule {
    name     = "rule-1"
    priority = 1

    action {
      count {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "webacl1-ratebasedrule"
      sampled_requests_enabled   = false
    }
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