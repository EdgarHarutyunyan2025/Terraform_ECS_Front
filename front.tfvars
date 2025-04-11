#============ VPC VARS ==============

main_vpc           = "192.168.0.0/16"
main_public_subnet = ["192.168.10.0/24", "192.168.20.0/24"]

#============ SG VARS ==============

sg_name     = "front_sg"
sg_owner    = "Edgar"
allow_ports = ["80", "8080", "22"]

#============ ECS VARS ==============

cluser_name  = "fargate_cluster"
service_name = "Front_Servise"
launch_type  = "FARGATE"

#============ ALB VARS ==============

lb_name                    = "FRONT-ALB"
internal                   = false
load_balancer_type         = "application"
enable_deletion_protection = false
tg_name                    = "my-tg"
tg_port                    = 80
tg_protocol                = "HTTP"
health_check_path          = "/index.html"
health_check_protocol      = "HTTP"
listener_port              = 80
listener_protocol          = "HTTP"


#============ Task Def VARS ==============

family                   = "Front"
network_mode             = "awsvpc"
requires_compatibilities = ["FARGATE"]
cpu                      = "512"
memory                   = "1024"
front_container_name     = "front-container"
container_image          = "nimmis/alpine-apache"
container_cpu            = 512
container_memory         = 1024
essential                = true
container_port           = 80
log_name                 = "front"
