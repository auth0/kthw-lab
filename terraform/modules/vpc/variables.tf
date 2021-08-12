variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
}

variable "private_cidr" {
  description = "CIDR for the Kubernetes the Hard Way network"
  type        = string
}

variable "cluster_cidr" {
  description = "CIDR for the Kubernetes cluster"
  type        = string
}

variable "ssh_hosts" {
  description = "list of host IPs to allow SSH access"
  type        = list(string)
}
