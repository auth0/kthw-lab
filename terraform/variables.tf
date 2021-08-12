variable "region" {
  description = "aws region"
  type        = string
  default     = "us-west-2"
}

variable "ssh_hosts" {
  description = "list of hosts to allow ssh access"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "name of the ssh key pair to assign to instances"
  type        = string
  default     = "becki-test"
}

variable "public_key" {
  description = "public key of the key pair"
  type        = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBOlarv1TdyqUr+E6zaNc8NM1u+oKqFon1JDueVLejFX+nlXu81TJuBSQvLOFKt1TmqUKoLkFGaOtKpda23kbByhVGOxGDeK8f3YaceBX5EYIS6UbsuyniY39oRCj7K2+D/FD50o6VEdHdRJYPwHDFH7sJudJIz4SWNppMvjU8qkFsX2HCVi8hZajjreF+ZmOHKq6N3X53GXR3LfXNVVdkM4jAERiI4RNvDwuajxpd/Jk+UTMMgJNdHFXVZRNeOXhhz5LyW3CdLhsIAOsT8kYeW/o7YZ0ItspnXfhbhS38qEs3P2qtRig8w4qL7XjcXf3FFiCp0e8G6/kWqGnR91Qb"
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