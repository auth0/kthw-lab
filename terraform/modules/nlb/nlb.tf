
resource "aws_lb" "nlb" {
  name               = "kubernetes-the-hard-way-nlb"
  internal           = false
  load_balancer_type = "network"
  subnet_mapping {
    subnet_id     = var.subnet_id
    allocation_id = var.eip_id
  }

  enable_deletion_protection = false

  tags = var.default_tags
}

# create target group for controllers
resource "aws_lb_target_group" "controllers" {
  target_type = "ip"
  port        = "6443"
  protocol    = "TCP"
  vpc_id      = "vpc-0c08341e945820b05"

  health_check {
    enabled  = true
    protocol = "HTTPS"
    port     = "6443"
    path     = "/healthz"
  }
}

# target group attachements
resource "aws_lb_target_group_attachment" "controllers" {
  count = length(var.target_ips)

  target_group_arn = aws_lb_target_group.controllers.arn
  target_id        = var.target_ips[count.index]
  port             = 6443
}

# create kube api listener
resource "aws_lb_listener" "kube_api" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controllers.arn
  }
}