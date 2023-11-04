resource "aws_alb" "WAFalb" {
  name = "LoadBalancerforWAF"
  internal = false
  load_balancer_type = "application"
  subnets = ["subnet-0b87f5a41a45f25d0","subnet-0caef868037a71b9b"]
}