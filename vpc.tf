
#%%%%%%%%%%%%%% VPC CREATION WITH ALL ASSOCIATED RESOURCES NEEDED %%%%%%%%%%%%%%%%

# Creation of The VPC
resource "aws_vpc" "vpc1" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Terraform-vpc"
    env  = "dev"
    Team = "DevOps"
  }
}

# Creation of Internet Gatway:
resource "aws_internet_gateway" "gwy1" {
  vpc_id = aws_vpc.vpc1.id
}
# Creation of Public Subnets:
resource "aws_subnet" "public1" {
    availability_zone = "us-east-1a"
    cidr_block = "192.168.1.0/24"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.vpc1.id
    tags={
        Name = "public-subnet-1"
        env = "dev"
    }  
}
resource "aws_subnet" "public2" {
    availability_zone = "us-east-1b"
    cidr_block = "192.168.2.0/24"
    vpc_id = aws_vpc.vpc1.id
    map_public_ip_on_launch = true
    tags={
        Name = "public-subnet-2"
        env = "dev"
    }  
}

# Creation of Private Subnets
resource "aws_subnet" "private1" {
    availability_zone = "us-east-1a"
    cidr_block = "192.168.3.0/24"
    vpc_id = aws_vpc.vpc1.id
    tags={
        Name = "private-subnet-1"
        env = "dev"
    } 
}
resource "aws_subnet" "private2" {
    availability_zone = "us-east-1b"
    cidr_block = "192.168.4.0/24"
    vpc_id = aws_vpc.vpc1.id
    tags={
        Name = "private-subnet-2"
        env = "dev"
    }
  
}
# Creation of Elastic ip
resource "aws_eip" "eip" {
 
}

# Creation of Nat Gateway 
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public1.id
}

# Creation of Public route table
resource "aws_route_table" "rtpublic" {
 vpc_id = aws_vpc.vpc1.id 
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gwy1.id
 }
}

# Creation of Private route
resource "aws_route_table" "rtprivate" {
 vpc_id = aws_vpc.vpc1.id 
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
 }
}


# Creation of Subnet association
resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "rta3" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpublic.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpublic.id
}

