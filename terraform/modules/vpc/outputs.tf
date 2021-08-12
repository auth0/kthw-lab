output "vpc_id" {
  description = "vpc id"
  value = aws_vpc.main.id
}

output "subnet_id" {
  description = "subnet id for the subnet created in vpc"
  value       = aws_subnet.main.id
}

output "sg_internal_id" {
  description = "id of the internal security group"
  value       = aws_security_group.kube_internal.id
}

output "sg_external_id" {
  description = "id of the external security group"
  value       = aws_security_group.kube_external.id
}