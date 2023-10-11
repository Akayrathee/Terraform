

resource "aws_alb" "WAFalb" {
  name = "LoadBalancerforWAF"
  internal = false
  load_balancer_type = "application"
  subnets = ["subnet-019415913af29605b","subnet-06b600c5b6c1e0b6b"]
}