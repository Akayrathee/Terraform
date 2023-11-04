resource "aws_wafv2_web_acl" "webacl1" {
  name        = "Domo-Demo1-WAF"
  description = "WAF used on Demo1 ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

# For evry rule you need to add another rule block
  # rule {
  #   name     = "rule-1"
  #   priority = 1

  #   action {
  #     count {}
  #   }

  #   statement {
  #     rate_based_statement {
  #       limit              = 10000
  #       aggregate_key_type = "IP"
  #     }
  #   }

  #   visibility_config {
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "webacl1-ratebasedrule"
  #     sampled_requests_enabled   = false
  #   }
  # }

  
  rule {
    name = "DomoDomainAccept"
    priority = 0

    action {
      block {}
    }

    statement {
      not_statement {
        statement {
          regex_pattern_set_reference_statement {
            field_to_match {
              single_header {
                name = "host"
              }
            }
            arn = aws_wafv2_regex_pattern_set.DomoHostNames.arn
            text_transformation {
              type = "NONE"
              priority = 0
            }
          }
        }
      }
    }

    visibility_config {
      sampled_requests_enabled = false
      cloudwatch_metrics_enabled = true
      metric_name = "DomoDomainAccept"
  }
  }

  rule {
    name = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }
    
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesAmazonIpReputationList"
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "AWSManagedIPReputationList"
        }
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "AWSManagedReconnaissanceList"
        }
      }
    }
    visibility_config {
      sampled_requests_enabled = false
      cloudwatch_metrics_enabled = true
      metric_name = "AWS-AWSManagedRulesAmazonIpReputationList"
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