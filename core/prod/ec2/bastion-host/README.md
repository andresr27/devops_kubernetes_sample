
# Deploy Bastion for EKS

Terraform and Ansible module to install an EC2 Bastion Server to connect to EKS clusters.

## Terraform setup

### AWS Login
First, we should export the AWS profile we want to use and log into AWS using the command line tool.

```bash
  export AWS_PROFILE="bastion_prod_devops"
  aws sso login
```

A browser tab will open, and you need to follow the AWS login instruction, including MF codes, to get authenticated.

### Backend Login 
Use the following command to login into the Terraform BE:

```bash
terraform login backend.service
```

This will redirect to the BE log in, use your SSO for login in.
    
## Run Terraform

Run the initial setup for terraform plus the plan and apply commands:

```bash1
  # terraform init 
  # terraform plan
  # terraform apply
```

Once you run the last command to apply your changes, you will notice an output related to the private ip address for your EC2 server. 
This module sets a dns record named "bastion" into the specified dns zone your terraform bastion.tf file. 
You can also use this ip address to connect to the server if you want to.

```bash1
instance_ips = [
  "172.0.0.235",
]
```

## Copy Ansible files to server
The Ansible package was already installed by the Terraform module. So you can copy the ansible module folder and run it locally.

```bash1
 # scp -i "~/.ssh/devops-ssh-key.pem" -r ./ansible ubuntu@bastion.sample-comp.io:
```

The command above copy the ansible folder into the home directory of the ubuntu user.

Then, you should log into the EC2 server and enter into the ansible folder located in the ubuntu home directory.

```bash1
# ssh -i "~/.ssh/devops-ssh-key.pem" ubuntu@bastion.sample-comp.io
# cd ansible
```

### Create an initial configuration file for ansible

```bash1
# ansible-config init --disabled > ansible.cfg
```

### Run the playbook
```bash1
# ansible-playbook playbook.yml
```

This playbook will ask you to paste the AWS KEY ID and AWS SECRET ID. Ask the Devops team to provide the keys.

## Testing
Try running these commands, output should be similar to this:
```bash1
# kubectx arn:aws:eks:us-west-2:*************:cluster/sample-eks-cluster
  ✔ Switched to context "arn:aws:eks:us-west-2:*************:cluster/sample-eks-cluster".
# kubectl version
  Client Version: v1.30.2
  Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
  Server Version: v1.30.0-eks-036c24b
```

## Fluent-bit configuration
In order to run fluent-bit successfully, you need to export the following env variables in the OS. You can get the values from AWS Secrets Manager service:
```bash1
# export OS_DOMAIN_HOST=<value obtained from secrets>
# export OS_AUTH_USER=<value obtained from secrets>
# export OS_AUTH_PASS=<value obtained from secrets>
```

Then, restart fluent-bit service
```bash1
# sudo systemctl restart fluent-bit
```