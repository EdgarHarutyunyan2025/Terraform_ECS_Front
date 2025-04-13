output "load_balancer_dns_name" {
  value = module.aws_alb.alb_dns_name
}

output "ecs_service_front" {
  value = module.aws_ecs_service_front.ecs_service_name
}

