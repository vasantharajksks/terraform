Architecture diagram of nginx server
![click](nginx cloud server.jpg)

Create the following resources using terraform:

Create 1 VPC
eg : ninja-vpc-01

![click](Screenshot from 2022-02-08 03-35-06.png)

Create 4 Subnet
2 public subnet
eg : ninja-pub-sub-01/02

![click](Screenshot from 2022-02-08 03-34-19.png)

2 private subnet
eg : ninja-priv-sub-01/02

![click](Screenshot from 2022-02-08 03-31-58.png)

Create 1 IGW
eg : ninja-igw-01
Create 1 NAT
eg : ninja-nat-01

Create 2 Route Table
1 for public subnet
eg : ninja-route-pub-01/02
1 for private subnet
eg : ninja-route-priv-01/02

Create  ec2-instances based on your assigned software(cluster or HA)
eg : mongo-master
eg : mongo-slave-1

![click](Screenshot from 2022-02-08 03-31-58.png)

Create one bastion host
eg : bastion-host

![click](Screenshot from 2022-02-08 03-31-34.png)

Create  Security Groups for  your EC2 instances

port 22 of bastion host should only accessible from your public ip.
port 22 of the private instances should only be accessible from  bastion host
port {Software_Port} of the private instances should only be accessible from bastion host


Expiration actions – These actions define when objects expire. Amazon S3 deletes expired objects on your behalf.


