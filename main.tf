# MY VPC
resource "aws_vpc" "WABO-VPC" {
  cidr_block       = var.cidr-for-vpc
  instance_tenancy = "default"

  tags = {
    Name = "WABO-VPC"
  }
}

#PUBLIC SUBNET
resource "aws_subnet" "PUBLIC-SUB1" {
  vpc_id     = aws_vpc.WABO-VPC.id
  cidr_block = var.cidr-for-public-sub1

  tags = {
    Name = "PUBLIC-SUB1"
  }
}

#PUBLIC SUBNET
resource "aws_subnet" "PUBLIC-SUB2" {
  vpc_id     = aws_vpc.WABO-VPC.id
  cidr_block = var.cidr-for-public-sub2

  tags = {
    Name = "PUBLIC-SUB2"
  }
}

#PRIVATE SUBNET
resource "aws_subnet" "PRIVATE-SUB1" {
  vpc_id     = aws_vpc.WABO-VPC.id
  cidr_block = var.cidr-for-private-sub1

  tags = {
    Name = "PRIVATE-SUB1"
  }
}

#PRIVATE SUBNET
resource "aws_subnet" "PRIVATE-SUB2" {
  vpc_id     = aws_vpc.WABO-VPC.id
  cidr_block = var.cidr-for-private-sub2 

  tags = {
    Name = "PRIVATE-SUB2"
  }
}

#PUBLIC ROUTE TABLE
resource "aws_route_table" "PUBLIC-ROUTE-TABLE" {
  vpc_id = aws_vpc.WABO-VPC.id

 tags = {
    Name = "PUBLIC-ROUTE-TABLE"
  }
}

#PRIVATE ROUTE TABLE
resource "aws_route_table" "PRIVATE-ROUTE-TABLE" {
  vpc_id = aws_vpc.WABO-VPC.id

  tags = {
    Name = "PRIVATE-ROUTE-TABLE"
  }
}

#ROUTE ASSOCIATION PUBLIC
resource "aws_route_table_association" "PUBLIC-ROUTE-TABLE-ASSOCIATION-1" {
  subnet_id      = aws_subnet.PUBLIC-SUB1.id
  route_table_id = aws_route_table.PUBLIC-ROUTE-TABLE.id
}

resource "aws_route_table_association" "PUBLIC-ROUTE-TABLE-ASSOCIATION-2" {
  subnet_id      = aws_subnet.PUBLIC-SUB2.id
  route_table_id = aws_route_table.PUBLIC-ROUTE-TABLE.id
}

#ROUTE ASSOCIATION PRIVATE
resource "aws_route_table_association" "PRIVATE-ROUTE-TABLE-ASSOCIATION-1" {
  subnet_id      = aws_subnet.PRIVATE-SUB1.id
  route_table_id = aws_route_table.PRIVATE-ROUTE-TABLE.id
}

resource "aws_route_table_association" "PRIVATE-ROUTE-TABLE-ASSOCIATION-2" {
  subnet_id      = aws_subnet.PRIVATE-SUB2.id
  route_table_id = aws_route_table.PRIVATE-ROUTE-TABLE.id
}

#INTERNET GATEWAY
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.WABO-VPC.id

  tags = {
    Name = "IGW"
  }
}


#AWS ROUTE
resource "aws_route" "PUBLIC-IGW-ROUTE" {
  route_table_id            = aws_route_table.PUBLIC-ROUTE-TABLE.id
  gateway_id                =aws_internet_gateway.IGW.id
  destination_cidr_block    = "0.0.0.0/0"
}
# Nat Gateway for internet through the public subnet

resource "aws_eip" "EIP_for_NG" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.6"
  }

resource "aws_nat_gateway" "WABOsNGW" {
  allocation_id = aws_eip.EIP_for_NG.idgit
  subnet_id     = aws_subnet.PUBLIC-SUB1.id
 }
 
# Route NAT GW with private Route table
resource "aws_route" "NatGW-association_with-private_RT" {
  route_table_id         = aws_route_table.PRIVATE-ROUTE-TABLE.id
  nat_gateway_id         = aws_nat_gateway.WABOsNGW.id
  destination_cidr_block = "0.0.0.0/0"
}