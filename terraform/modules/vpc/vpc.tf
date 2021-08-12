# create vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# create subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr
}

# create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# create route table and associate IGW and subnet with it
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "nodes" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

# create security group for external connections
resource "aws_security_group" "kube_external" {
  name        = "kubernetes-the-hard-way-external"
  description = "allow external"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "tcp"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_hosts

  }

  ingress {
    description = "udp"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "icmp"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "kubernetes-the-hard-way-allow-external"
    },
  )
}

# create security group for internal connections
resource "aws_security_group" "kube_internal" {
  name        = "kubernetes-the-hard-way-internal"
  description = "allow internal communications"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "tcp"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.private_cidr, var.cluster_cidr]
  }

  ingress {
    description = "udp"
    from_port   = 0
    to_port     = 0
    protocol    = "udp"
    cidr_blocks = [var.private_cidr, var.cluster_cidr]
  }

  ingress {
    description = "icmp"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [var.private_cidr, var.cluster_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "kubernetes-the-hard-way-allow-internal"
    },
  )
}
