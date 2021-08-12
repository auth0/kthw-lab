
## README  

This is useful if you are studying for you CKA, and are wanting to use [Kubernetes The Hard Way (kthw) by Kelsey Hightower](https://github.com/kelseyhightower/kubernetes-the-hard-way) on AWS instead of on GCP

This code deploys and configures the network infrastructure for doing the labs. It covers some or all of the steps required in labs 3 and 4.  

The idea is to be able to save time setting up the VPC, remote access, firewall rules, compute instances, and the client certs each time you want to do the lab.   

## Network

The network consists of:

* 3 control nodes ips:
   - controller-0: 10.240.0.10
   - controller-1: 10.240.0.11
   - controller-2: 10.240.0.12
* 3 worker nodes ips: 
   - worker-0: 10.240.0.20
   - worker-1: 10.240.0.21
   - worker-2: 10.240.0.22
* 3 pods ips: 
   - pod-0: 10.200.0.0/24
   - pod-1: 10.200.1.0/24
   - pod-2: 10.200.2.0/24 

## KTHW Labs

1. Clone this repo and make a branch for yourself - or fork it
1. Read [KTHW Lab 1](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/01-prerequisites.md). The tips on using tmux are very helpful.
1. Install client tools in [KTHW Lab 2](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/02-client-tools.md) on your laptop.
1. Update the main variables.tf with: 
   - your SSH key name
   - your SSH public key value
   - your external / public IP address to add to the SSH allow security group
1. Run the terraform code after updating your variable values in the variables.tf file. 
   - This will cover [KTHW Lab 3](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md). 
   - **Note the public IP address in the output. You'll need that later**.
   - verify that you can SSH to the public IP of the `controller-0` instance
1. Follow the steps in [KTHW Lab 4](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md), 
   - **you might want to make a `kthw` directory on your laptop to hold all the certs your are going to create in lab 4**
   - for the Kublet Client Certificates:
      - run the code in the `for` loop to create csr.json files:
      ```
      for instance in worker-0 worker-1 worker-2; do
        cat > ${instance}-csr.json <<EOF
        {
        "CN": "system:node:${instance}",
        "key": {
            "algo": "rsa",
            "size": 2048
        },
        "names": [
            {
            "C": "US",
            "L": "Portland",
            "O": "system:nodes",
            "OU": "Kubernetes The Hard Way",
            "ST": "Oregon"
            }
        ]
        }
        EOF
      done
```
      - then run the `kube-client-cert.py` script to install the Kublet Client Certificates on the worker nodes.
1. Follow the instructions in the remaining labs 

#### Save Money

Run `gk e -p security-dev terraform -destroy` when you are done working with your lab. You can recreate the network when you're ready to go again.

## Happy Labing and Good Luck with the CKA!