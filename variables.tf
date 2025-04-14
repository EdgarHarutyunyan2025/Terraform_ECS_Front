#============ VPC VARS ==============

variable "main_vpc" {
  default = "192.168.0.0/16"
}

variable "main_public_subnet" {
  default = ["192.168.10.0/24", "192.168.20.0/24"]
}

#============ SG VARS ==============

variable "sg_name" {
  default = "fargate-sg"
}

variable "sg_owner" {
  default = "Edgar"
}

variable "allow_ports" {
  default = ["80", "8080", "22"]
}


#============ ECS VARS ==============


variable "docker_image" {
  default = ""
}

variable "cluser_name" {
  default = "fargate_cluster"
}

variable "service_name" {
  default = "Front_Servise"
}

variable "launch_type" {
  default = "FARGATE"
}

#============ ALB VARS ==============

variable "lb_name" {
  default = "FRONT-ALB"
}

variable "internal" {
  default = false
}

variable "load_balancer_type" {
  default = "application"
}

variable "enable_deletion_protection" {
  default = false
}

variable "tg_name" {
  default = "FRONT-TG"
}

variable "tg_port" {
  default = 80
}

variable "health_check_port" {
  default = 80
}

variable "tg_protocol" {
  default = "HTTP"
}

variable "health_check_path" {
  default = "/index.html"
}

variable "health_check_protocol" {
  default = "HTTP"
}

variable "listener_port" {
  default = 80
}

variable "listener_protocol" {
  default = "HTTP"
}

#============ Task Def VARS ==============

variable "family" {
  default = "front"
}

variable "network_mode" {
  default = "awsvpc"
}

variable "requires_compatibilities" {
  default = ["FARGATE"]
}

variable "cpu" {
  default = "512"
}

variable "memory" {
  default = "1024"
}

variable "front_container_name" {
  default = "front-container"
}

variable "container_image" {
  default = "nimmis/alpine-apache"
}

variable "container_cpu" {
  type    = number
  default = 512
}

variable "container_memory" {
  type    = number
  default = 1024
}

variable "essential" {
  default = true
}

variable "container_port" {
  default = 80
}

variable "log_name" {
  default = "front"
}

variable "s3_name" {
  default = "frontend-test111-bucket"
}

