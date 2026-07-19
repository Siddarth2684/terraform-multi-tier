module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
}

module "compute" {
  source = "./modules/compute"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_type      = var.instance_type

  web_security_group_id = module.security.web_security_group_id
  instance_profile_name = module.security.instance_profile_name

  target_group_arn = module.alb.target_group_arn
}



############################################################
# Cloud Watch monitoring and Alarm
############################################################
module "monitoring" {
  source = "./modules/monitoring"

  project_name           = var.project_name
  autoscaling_group_name = module.compute.autoscaling_group_name
  notification_email     = var.notification_email
}