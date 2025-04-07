output "load_balancer_dns_name" {
  value = module.aws_alb.alb_dns_name
}

output "FRONT_CLUSTER_NAME" {
  value = module.aws_ecs_cluster.ecs_cluster_name
}

output "FRONT_CLUSTER_ID" {
  value = module.aws_ecs_cluster.ecs_cluster_id
}

output "ecs_service_front" {
  value = module.aws_ecs_service_front.ecs_service_name
}

output "FRONT_VPC_ID" {
  value = module.vpc-main.main_vpc_id
}

output "FRONT_VPC_SUBNET_IDS" {
  value = module.vpc-main.public_subnet_ids
}
