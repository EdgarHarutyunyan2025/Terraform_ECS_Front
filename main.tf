provider "aws" {
  region = "eu-central-1"
}

module "vpc-main" {
  source              = "../modules/vpc"
  vpc_name            = "front-VPC"
  vpc_cidr            = var.main_vpc
  public_subnet_cidrs = var.main_public_subnet
}

module "ecr_front" {
  source       = "../modules/ecr"
  ecr_name     = "my_front_ecr"
  docker-image = "ecr"
}

module "front_sg" {
  source      = "../modules/sg"
  allow_ports = var.allow_ports
  vpc_id      = module.vpc-main.main_vpc_id

  sg_name  = var.sg_name
  sg_owner = var.sg_owner
}

module "role_s3" {
  source = "../modules/role_front"

  log_name = var.log_name
}

module "aws_ecs_cluster" {
  source      = "../modules/ecs_cluster"
  cluser_name = "Fargate-Cluster"
}


#========= ECS SERVICE ===========

module "aws_ecs_service_front" {
  source                  = "../modules/ecs_sevice"
  cluser_name             = module.aws_ecs_cluster.ecs_cluster_name
  service_name            = "Front-Service"
  cluster_id              = module.aws_ecs_cluster.ecs_cluster_id
  task_definition_id      = module.task_definition_front.task_definition_id
  launch_type             = var.launch_type
  service_subnets         = [module.vpc-main.public_subnet_ids[0]]
  service_security_groups = [module.front_sg.sg_id]

  target_group_arn = module.aws_alb.alb_tg_arn
  container_name   = var.front_container_name
  container_port   = var.container_port

  depends_on = [module.aws_ecs_cluster]
}

#========= Task Definition ===========

module "task_definition_front" {
  source                   = "../modules/task_definition"
  family                   = "front"
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = module.role_s3.s3full_arn
  task_role_arn            = module.role_s3.s3full_arn

  container_name   = var.front_container_name
  container_image  = module.ecr_front.repository_url
  container_cpu    = var.container_cpu
  container_memory = var.container_memory
  essential        = var.essential
  container_port   = var.container_port
  host_port        = var.container_port

  log_name = "front"


  depends_on = [module.ecr_front, module.aws_ecs_cluster]
}

module "aws_alb" {
  source                     = "../modules/load_balancer"
  lb_name                    = var.lb_name
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [module.front_sg.sg_id]
  subnets                    = module.vpc-main.public_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection

  tg_name     = var.tg_name
  tg_port     = var.tg_port
  tg_protocol = var.tg_protocol
  vpc_id      = module.vpc-main.main_vpc_id

  health_check_path     = var.health_check_path
  health_check_protocol = var.health_check_protocol

  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol
}

#========= Autoscaling Group ===========


module "autoscaling_group_front" {
  source       = "../modules/autoscaling_group"
  resource_id  = "service/${module.aws_ecs_cluster.ecs_cluster_name}/${module.aws_ecs_service_front.ecs_service_name}"
  max_capacity = 1
  min_capacity = 1
}


resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = var.log_name
}
