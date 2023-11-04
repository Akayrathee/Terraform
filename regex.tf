resource "aws_wafv2_regex_pattern_set" "DomoHostNames" {
  name        = "DomoHostNames"
  description = "DomoHostNames regex pattern set"
  scope       = "REGIONAL"

  regular_expression {
    regex_string = "^(([a-zA-Z0-9_-]+)\\.)+(maestromanager\\.net)$"
  }

  regular_expression {
    regex_string = "^(([a-zA-Z0-9_-]+)\\.)+(domo((\\.com)|(\\.buzz)|(tech\\.io)|(software\\.net)))$"
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}