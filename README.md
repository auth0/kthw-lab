
## README  

This is useful if you are studying for you CKA, and are wanting to use [Kubernetes The Hard Way (kthw) by Kelsey Hightower](https://github.com/kelseyhightower/kubernetes-the-hard-way) on AWS instead of on GCP

This code deploys and configures the network infrastructure for doing the labs. It also has code to create and distribute certs.  

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

### Lab 1

1. Read [KTHW Lab 1](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/01-prerequisites.md). The tips on using tmux are very helpful.

### Lab 2

1. Install client tools in [KTHW Lab 2](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/02-client-tools.md) on your laptop.

### Lab 3

1. Update the main variables.tf with: 
   - your SSH key name
   - your SSH public key value
   - your external / public IP address to add to the SSH allow security group
1. Run the terraform code after updating your variable values in the variables.tf file. 
   - This will cover [KTHW Lab 3](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md). 
   - **Note the public IP address in the output. You'll need that later**.
   - verify that you can SSH to the public IP of the `controller-0` instance

### Lab 4

1. Follow the steps in [KTHW Lab 4](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md), 
1. Make a `~/kthw` directory on your laptop to hold all the certs you are going to create
1. Make all the certificates in the lab except until you get to the Kubelet Client Certificates

#### Kubelet Client Certificates

1. Run the code in the `for` loop to create the worker -csr.json files
1. Then run the `kube-client-cert.py` script to create the worker certs.
1. Create the remaining certs in Lab 4 until you get to the Distribute Client and Server Certs Step. 

#### Distribute the Client and Server Certificates

You can use the following commands after updating to use your SSH key name, and the value for the owner tag you used in your Terraform code. This assumes you put your certs in your `~/kthw` directory
```
key="~/.ssh/becki-test.pem"
owner="becki"
for instance in worker-0 worker-1 worker-2; do
    ip=`gk e -p security-dev -- aws ec2 describe-instances --filters "Name=tag:Name,Values=${instance}" "Name=tag:owner,Values=${owner}"  | jq -r '.[] | .[0].Instances[0].PublicIpAddress'`
    scp -o user=ubuntu -i ${key} ~/kthw/ca.pem ~/kthw/${instance}-key.pem ~/kthw/${instance}.pem $ip:~/
done


for instance in controller-0 controller-1 controller-2; do
    ip=`gk e -p security-dev -- aws ec2 describe-instances --filters "Name=tag:Name,Values=${instance}" | jq -r '.[] | .[0].Instances[0].PublicIpAddress'`
    scp -o user=ubuntu -i ${key} ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem $ip:~/
done
```

### Lab 5

 **the public address for Lab 5 can be found in the Terraform output**
1. Follow the instructions in [Lab 5](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/05-kubernetes-configuration-files.md) until the last step. You can use this code to Distribute the Kubernetes Files
```
for instance in worker-0 worker-1 worker-2; do
    ip=`gk e -p security-dev -- aws ec2 describe-instances --filters "Name=tag:Name,Values=${instance}" "Name=tag:owner,Values=${owner}" | jq -r '.[] | .[0].Instances[0].PublicIpAddress'`
    scp -o user=ubuntu -i ${key} ${instance}.kubeconfig kube-proxy.kubeconfig $ip:~/
done

for instance in controller-0 controller-1 controller-2; do
    ip=`gk e -p security-dev -- aws ec2 describe-instances --filters "Name=tag:Name,Values=${instance}" "Name=tag:owner,Values=${owner}" | jq -r '.[] | .[0].Instances[0].PublicIpAddress'`
    scp -o user=ubuntu -i ${key} admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig $ip:~/
done
```

### Lab 6

1. Follow the instructions in [Lab 6](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/06-data-encryption-keys.md)
1. Code to copy the encryption key to the controller nodes
```
for instance in controller-0 controller-1 controller-2; do
    ip=`gk e -p security-dev -- aws ec2 describe-instances --filters "Name=tag:Name,Values=${instance}" "Name=tag:owner,Values=${owner}" | jq -r '.[] | .[0].Instances[0].PublicIpAddress'`
    scp -o user=ubuntu -i ${key} encryption-config.yaml $ip:~/
done
```

### Remaining Labs

You should be able to follow the instructions for the rest of the labs

## Save Money

Run `gk e -p security-dev terraform -destroy` when you are done working with your lab. You can recreate the network and start with Lab 4 when you're ready to go again.

## Happy Labing and Good Luck with the CKA!