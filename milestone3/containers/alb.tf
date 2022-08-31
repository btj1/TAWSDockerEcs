resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ALBSG]
  subnets            = [for r in var.PublicSubnet_IDs : r]
 
  enable_deletion_protection = false
}
 
resource "aws_alb_target_group" "main" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
 
  health_check {
   port                = "traffic-port"
   healthy_threshold   = "2"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = "/"
   unhealthy_threshold = "10"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"
 
  default_action {
   type = "forward"
   target_group_arn = aws_alb_target_group.main.arn
   
  }
}
 
