variable "region" {
  description = "aws region"
  type        = string
  default     = "us-west-2"
}

variable "aws_credentials_file" {
  description = "file path to credentials"
  type        = string
  default     = "~/.aws/credentials"
}

variable "aws_profile" {
  description = "aws profile credentials to use"
  type        = string
  default     = "default"
}

variable "default_tags" {
  type = map(any)
  default = {
    Name : "kubernetes-the-hard-way"
    Terraform : "true"
    stage : "lab"
  }
}

variable "ssh_hosts" {
  description = "list of hosts to allow ssh access"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "name of the ssh key pair to assign to instances"
  type        = string
}

variable "public_key" {
  description = "public key of the key pair"
  type        = string
}

variable "controller_ips" {
  type = map(any)
  default = {
    controller-0 = "10.240.0.10"
    controller-1 = "10.240.0.11"
    controller-2 = "10.240.0.12"
  }
}

variable "worker_ips" {
  type    = list(string)
  default = ["10.240.0.20", "10.240.0.21", "10.240.0.22"]
}

variable "pod_ips" {
  type    = list(string)
  default = ["10.200.0.0/24", "10.200.1.0/24", "10.200.2.0/24"]
}