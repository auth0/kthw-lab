variable "vpc_id" {
  description = "the id of the vpc"
  type = string
}

variable "subnet_id" {
  description = "the subnet id that is behind the load balancer"
  type        = string
}

variable "eip_id" {
  description = "the id of the elastic ip to be associated with the NLB"
  type        = string
}

variable "target_ips" {
  description = "the list of controller ips to attach to the target groups"
  type        = list(string)
  default     = ["10.240.0.10", "10.240.0.11", "10.240.0.12"]
}
