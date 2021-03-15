variable "subnet_id" {
  description = "subnet id to launch instances in"
  type        = string
}

variable "key_name" {
  description = "name of the key pair to use with instances"
  type        = string
}

variable "sg_ids" {
  description = "list of security groups to associate with"
  type        = list(string)
}

variable "controller_ips" {
  description = "list of private IP addresses to assocaiate the controller nodes"
  type        = map(string)
}

variable "worker_ips" {
  description = "list of private IP addresses to assocaiate the worker nodes"
  type        = list(string)
}

variable "pod_ips" {
  description = "list of private IP addresses to pass to the worker nodes for pods"
  type        = list(string)
}

variable "default_tags" {
  default     = {}
  description = "default tags"
  type        = map(string)
}