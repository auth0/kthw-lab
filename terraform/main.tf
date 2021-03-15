provider "aws" {
  region                  = var.region
  shared_credentials_file = var.aws_credentials_file
  profile                 = var.aws_profile
}

output "public_ip" {
  value = aws_eip.lb.public_ip
}

# create network resources 
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = "10.240.0.0/22"
  private_cidr = "10.240.0.0/24"
  cluster_cidr = "10.200.0.0/16"
  ssh_hosts    = var.ssh_hosts
  default_tags = var.default_tags
}

# upload keypair
resource "aws_key_pair" "kube-key" {
  key_name   = var.key_name
  public_key = var.public_key
  tags       = var.default_tags
}

# launch controller and worker nodes
module "kubernetes_compute" {
  source         = "./modules/compute"
  key_name       = aws_key_pair.kube-key.key_name
  subnet_id      = module.vpc.subnet_id
  sg_ids         = [module.vpc.sg_internal_id, module.vpc.sg_external_id]
  controller_ips = var.controller_ips
  worker_ips     = var.worker_ips
  pod_ips        = var.pod_ips
  default_tags   = var.default_tags
}

# IP for NLB, but we need this now for future labs
resource "aws_eip" "lb" {
  vpc  = true
  tags = var.default_tags
}

/*  
uncomment when you are ready to create the network load balancer - 
they aren't inexpensive
*/

# create load balancer for Kubernetes API servers
module "nlb" {
  source       = "./modules/nlb"
  subnet_id    = module.vpc.subnet_id
  eip_id       = aws_eip.lb.id
  default_tags = var.default_tags
}
