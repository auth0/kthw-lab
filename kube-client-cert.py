import boto3
import boto3.session
import os


def create_client_cert(worker):
    instance = worker['instance_name']
    public_ip = worker['public_ip']
    private_ip = worker['private_ip']

    hostname = '-hostname=' + instance + ',' + public_ip + ',' + private_ip
    csr_json = instance + '-csr.json | cfssljson -bare ' + instance

    command = "cd ~/kthw/ \n"
    gen_cert = ( 
        "cfssl gencert -ca=ca.pem -ca-key=ca-key.pem "
        "-config=ca-config.json -profile=kubernetes"
    )

    gen_cert = gen_cert + " " + hostname + " " + csr_json

    command = command + gen_cert
    os.system(command)


def get_instance_data(worker_names):
    my_session = boto3.session.Session(region_name='us-west-2')

    ec2 = my_session.client('ec2')

    workers = []

    for worker in worker_names:
        tag = worker

        response = ec2.describe_instances(
            Filters=[
                {
                    'Name': 'tag:Name',
                    'Values':  [tag]
                },
            ],
        )

        instance = response['Reservations'][0]['Instances'][0]

        data = {
            "instance_name": worker,
            "instance_id": instance['InstanceId'],
            "private_ip": instance['PrivateIpAddress'],
            "public_ip": instance['PublicIpAddress']
        }

        workers.append(data)
    return workers


def main():
    worker_names = [
        "worker-0",
        "worker-1",
        "worker-2"
    ]
    worker_data = get_instance_data(worker_names)
    for worker in worker_data:
        create_client_cert(worker)


if __name__ == "__main__":
    main()
