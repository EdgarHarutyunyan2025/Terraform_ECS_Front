#========= S3 ===========

resource "aws_s3_bucket" "web_files" {
  bucket = var.s3_name
}

resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.web_files.id
  key    = "index.html"
  source = "./web_server/index.html"
  acl    = "private"
}


#======== ECR ===========

module "ecr_front" {
  source       = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//ecr"
  ecr_name     = "my_front_ecr"
  docker-image = var.docker_image

  lifecycle_description  = "Delete untagged images older than 1 day"
  lifecycle_tag_status   = "untagged"
  lifecycle_count_type   = "sinceImagePushed"
  lifecycle_count_number = 1
}

#========= SG ===========

module "front_sg" {
  source      = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//sg"
  allow_ports = var.allow_ports
  vpc_id      = data.terraform_remote_state.back.outputs.MAIN_VPC_ID

  sg_name  = var.sg_name
  sg_owner = var.sg_owner
}

#========= S3 ROLE ===========

module "role_s3" {
  #source = "../modules/role_front"
  source = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//role_front"

  log_name = var.log_name
}

#========= ECS SERVICE ===========

module "aws_ecs_service_front" {
  #source                  = "../modules/ecs_sevice"
  source                  = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//ecs_sevice"
  cluser_name             = data.terraform_remote_state.back.outputs.MAIN_CLUSTER_NAME
  service_name            = "Front-Service"
  cluster_id              = data.terraform_remote_state.back.outputs.MAIN_CLUSTER_ID
  task_definition_id      = module.task_definition_front.task_definition_id
  launch_type             = var.launch_type
  service_subnets         = data.terraform_remote_state.back.outputs.MAIN_VPC_SUBNET_IDS
  service_security_groups = [module.front_sg.sg_id]

  target_group_arn = module.aws_alb.alb_tg_arn
  container_name   = var.front_container_name
  container_port   = var.container_port

}

#========= Task Definition ===========

module "task_definition_front" {
  #source                   = "../modules/task_definition"
  source                   = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//task_definition"
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
  task_command     = ["sh", "-c", " aws s3 cp s3://${var.s3_name}/index.html /usr/local/apache2/htdocs/index.html && httpd -D FOREGROUND"]


  log_name = "front"


  depends_on = [module.ecr_front]
}

#========= ALB ===========

module "aws_alb" {
  source                     = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//load_balancer"
  lb_name                    = var.lb_name
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [module.front_sg.sg_id]
  subnets                    = data.terraform_remote_state.back.outputs.MAIN_VPC_SUBNET_IDS
  enable_deletion_protection = var.enable_deletion_protection

  tg_name     = var.tg_name
  tg_port     = var.tg_port
  tg_protocol = var.tg_protocol
  vpc_id      = data.terraform_remote_state.back.outputs.MAIN_VPC_ID

  health_check_path     = var.health_check_path
  health_check_protocol = var.health_check_protocol

  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol
}

#========= Autoscaling Group ===========


module "autoscaling_group_front" {
  source       = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//autoscaling_group"
  resource_id  = "service/${data.terraform_remote_state.back.outputs.MAIN_CLUSTER_NAME}/${module.aws_ecs_service_front.ecs_service_name}"
  max_capacity = 1
  min_capacity = 1
}


resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = var.log_name
}
