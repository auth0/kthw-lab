
## README  

This is useful if you are studying for you CKA, and are wanting to use [Kubernetest The Hard Way (kthw) by Kelsey Hightower] (https://github.com/kelseyhightower/kubernetes-the-hard-way) on AWS instead of on GCP

This code deploys and configures the network infrastructure for doing the labs. It covers some or all of the steps required in labs 3 and 4.  

The idea is to be able to save time setting up the VPC, remote access, firewall rules, compute instances, and the client certs each time  
you want to do the lab.   

## Network

The network consists of:

* 3 control nodes ips: 10.240.0.10, 10.240.0.11, 10.240.0.12
* 3 worker nodes ips: 10.240.0.20, 10.240.0.21, 10.240.0.22
* 3 pods ips: 10.200.0.0/24, 10.200.1.0/24, 10.200.2.0/24 

## KTHW Labs

1. Clone this repo and make a branch for yourself - or fork it
1. Read [KTHW Lab 1] (https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/01-prerequisites.md). The tips on using tmux are very helpful.
1. Install client tools in [KTHW Lab 2] (https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/02-client-tools.md)
1. Run the terraform code after updating your variable values in the variables.tf file. This will cover [KTHW Lab 3] (https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md). Note the public IP address in the output. You'll need that later.
1. Follow the steps in [KTHW Lab 4] (https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md), but run the kube-client-cert.py script to install the client certificates.
1. You should be able to follow the instructions in the remaining labs as they are written

#### Save Money

run `gk e -p security-dev terraform -destroy` when you are done working with your lab

## Happy Labing and Good Luck with the CKA!