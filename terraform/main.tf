provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Name : "kubernetes-the-hard-way"
      Terraform : "true"
      stage : "lab"
      owner: "becki"
    }
  }
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
}

# upload keypair
resource "aws_key_pair" "kube-key" {
  key_name   = var.key_name
  public_key = var.public_key
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
}

# IP for NLB, but we need this now for future labs
resource "aws_eip" "lb" {
  vpc  = true
}

# create load balancer for Kubernetes API servers
module "nlb" {
  source       = "./modules/nlb"
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.subnet_id
  eip_id       = aws_eip.lb.id
}
