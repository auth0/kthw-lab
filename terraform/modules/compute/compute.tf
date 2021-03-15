# find latest Canonical Ubuntu 20.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}

# create kubernetes controllers
resource "aws_instance" "kube_controller" {
  for_each = var.controller_ips

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  private_ip                  = each.value
  key_name                    = var.key_name
  vpc_security_group_ids      = var.sg_ids
  source_dest_check           = false
  associate_public_ip_address = true


  tags = merge(
    var.default_tags,
    {
      Name = "kubernetes-the-hard-way-${each.key}"
    },
  )
}

# create kubernetes workers
resource "aws_instance" "kube_worker" {
  count = length(var.worker_ips)

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  private_ip                  = var.worker_ips[count.index]
  key_name                    = var.key_name
  vpc_security_group_ids      = var.sg_ids
  source_dest_check           = false
  user_data                   = "pod-cidr=${var.pod_ips[count.index]}"
  associate_public_ip_address = true

  tags = merge(
    var.default_tags,
    {
      Name = "kubernetes-the-hard-way-worker-${count.index}"
    },
  )
}