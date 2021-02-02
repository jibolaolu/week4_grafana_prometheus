resource "aws_vpc" "monitor_VPC" {
  cidr_block           = "10.8.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "monitor_VPC"
  }
}

resource "aws_internet_gateway" "monitor_IGW" {
  vpc_id = aws_vpc.monitor_VPC.id

  tags = {
    Name = "monitor_IGW"
  }
}

resource "aws_subnet" "monitor_PublicSubnet" {
  cidr_block              = "10.8.1.0/24"
  vpc_id                  = aws_vpc.monitor_VPC.id
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "monitor_PrivateSubnet" {
  cidr_block        = "10.8.2.0/24"
  vpc_id            = aws_vpc.monitor_VPC.id
  availability_zone = "eu-west-2b"
}

resource "aws_route_table" "monitor_Public_RT" {
  vpc_id = aws_vpc.monitor_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.monitor_IGW.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.monitor_IGW.id
  }
}

#resource "aws_route" "monitor_route" {
#route_table_id = aws_route_table.monitor_Public_RT.id
#gateway_id = aws_internet_gateway.monitor_IGW.id
#destination_cidr_block = "0.0.0.0/0"

#}


resource "aws_route_table_association" "monitor_Public_RT_Assocition" {
  route_table_id = aws_route_table.monitor_Public_RT.id
  subnet_id      = aws_subnet.monitor_PublicSubnet.id
}

#resource "aws_route_table" "monitor_private_RT" {
  #vpc_id = aws_vpc.monitor_VPC.id
#}

#resource "aws_route_table_association" "monitor_Private_RT_Association" {
  #route_table_id = aws_route_table.monitor_private_RT.id
  #subnet_id      = aws_subnet.monitor_PrivateSubnet.id
#}
