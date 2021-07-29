# terraform-packer-demo
Tasks

1. Write code to deploy a VPC/Resource Group and EC2 instance/Azure virtual machine using the OSS CLI.  (Choose AWS, Azure, GCP.  Cloud doesn’t matter).
2. Install a web server or similar software on the VM using a provisioner.
3. Verify the installation was successful by accessing the service on the new server.    
4. Explain what Terraform plan, apply, and destroy does.
5. How does Terraform know what exists? 
6. Tear down the environment, and rewrite it to deploy to multiple regions.
7. Next, instead of using a provisioner, define the VM in Packer, and specify the created image in your Terraform code.  Does multi-region work with Packer?
8. What are some advantages of Packer?  What are some disadvantages?  
9. We just used a Terraform + Packer workflow.  Can you explain how we could use these tools to set up immutable infrastructure?  What else might we need?

## Write code to deploy a VPC/Resource Group and EC2 instance/Azure virtual machine using the OSS CLI.  (Choose AWS, Azure, GCP.  Cloud doesn’t matter).
I broke the code up into modules separating common requirements to facilitate deploying the same infrastructure to two AWS regions simultaneously.  My main module declares an AWS provider in the east and the west and then calls the common module for each region.  The common module creates resources that are required in each region (VPC, internet gateway, Subnet, Routes, security group, AMI).  The common module recieves an AWS provider as an input and outputs subnet_id, security_group_id and AMI_id. In practice, some of the common infrstructure could've been pulled into a separate workspace to delineate the roles of net-ops from dev-ops.

## Install a web server or similar software on the VM using a provisioner.
The outputs from the common module are fed to another module that creates vm instances and then modifies the images via cloud-init.  The cloud init script creates users, groups, uploads ssh public key, installs go and pulls a sample go app from github

## Verify the installation was successful by accessing the service on the new server.
execute login.sh to print the commands to start and then test the webapp by going to the displayed http://IP:8080
