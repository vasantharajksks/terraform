#creating vpc
resource "aws_vpc" "ninja-vpc" {
  cidr_block = var.vpcCidr
    tags = {
    Name = "vpc_ngnix"
  }
}

#creating public subnets
resource "aws_subnet" "pub-subnets" {
  count=var.pub_subnet_count
  vpc_id = aws_vpc.ninja-vpc.id
  cidr_block = cidrsubnet(var.vpcCidr,var.sub_cidr,count.index)
   availability_zone = element(data.aws_availability_zones.available.names,count.index)
   tags = {
    Name = "pub-subnet"
   }
}
#creating private subnets
resource "aws_subnet" "priv-subnets" {
  count=var.priv_subnet_count
  vpc_id = aws_vpc.ninja-vpc.id
  cidr_block = cidrsubnet(var.vpcCidr,var.sub_cidr,count.index + var.pub_subnet_count)
   availability_zone = element(data.aws_availability_zones.available.names,count.index+var.pub_subnet_count)
   tags = {
    Name = "priv-subnet"
   }
   depends_on = [
         aws_subnet.pub-subnets
       ]
}

#creating internet gateway
 resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ninja-vpc.id
 tags = {
    Name = "igw"
  }
}

#creating elastic ip
resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    "Name" = "Elastic_IP"
  }
}
#creating Nat Gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id = aws_subnet.pub-subnets[0].id
  tags = {
    "Name" = "ngw"
  }
}

#creating public route table
  resource "aws_route_table" "pub-route" {
  vpc_id = aws_vpc.ninja-vpc.id

  route {
    cidr_block = var.internet_ip
    gateway_id = aws_internet_gateway.igw.id
  }
}

#creating private route tabe
 resource "aws_route_table" "priv-route" {
  vpc_id = aws_vpc.ninja-vpc.id

  route {
    cidr_block = var.internet_ip
    nat_gateway_id         = aws_nat_gateway.ngw.id
  }
}

#associating route to pub subnet
resource "aws_route_table_association" "public-association" {
  count = var.pub_subnet_count
  route_table_id = aws_route_table.pub-route.id
  subnet_id      = aws_subnet.pub-subnets[count.index].id
}

#associating route to priv subnet
resource "aws_route_table_association" "priv-association" {
  count= var.priv_subnet_count
  route_table_id = aws_route_table.priv-route.id
  subnet_id      = aws_subnet.priv-subnets[count.index].id
}

#crerating security for public instance
resource "aws_security_group" "pub-ins-sg" {
  vpc_id      = aws_vpc.ninja-vpc.id
  dynamic "ingress" {
        for_each = var.pub-ins-sg
        content {
    from_port        = ingress.value.ports
    to_port          = ingress.value.ports
    protocol         = ingress.value.protocol
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
        }
     }
}


resource "aws_instance" "jenkins" {
  ami = "ami-08ee6644906ff4d6c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.pub-ins-sg.id]
  subnet_id = aws_subnet.pub-subnets[0].id
  key_name = "jenkins_mumbai"
  associate_public_ip_address = true
  tags = {
    Name = "jenkins"
  }
}

resource "aws_security_group" "priv-ins-sg" {
  vpc_id      = aws_vpc.ninja-vpc.id
  dynamic "ingress" {
        for_each = var.priv-ins-sg
        content {
    from_port        = ingress.value.ports
    to_port          = ingress.value.ports
    protocol         = ingress.value.protocol
    cidr_blocks      = ["${aws_instance.jenkins.private_ip}/32"]
        }
     }
}
resource "aws_instance" "sonarqube" {
  ami = "ami-08ee6644906ff4d6c"
  instance_type = "t2.small"
  vpc_security_group_ids = [aws_security_group.priv-ins-sg.id]
  subnet_id = aws_subnet.priv-subnets[0].id
  key_name = "jenkins_mumbai"
  associate_public_ip_address = false
  tags = {
    Name = "sonarqube"
  }
}
