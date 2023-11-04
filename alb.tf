

resource "aws_alb" "WAFalb" {
  name = "LoadBalancerforWAF"
  internal = false
  load_balancer_type = "application"
  subnets = ["subnet-05c317c270a250504","subnet-01c51bf168e1c3c4b"]
}