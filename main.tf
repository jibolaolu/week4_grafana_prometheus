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
  availability_zone = "eu-west-2a"
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

resource "aws_route_table_association" "monitor_Public_RT_Assocition" {
  route_table_id = aws_route_table.monitor_Public_RT.id
  subnet_id      = aws_subnet.monitor_PublicSubnet.id
}

resource "aws_route_table" "monitor_Private_RT" {
  vpc_id = aws_vpc.monitor_VPC.id
}

resource "aws_route_table_association" "monitor_private_RT_Association" {
  subnet_id      = aws_subnet.monitor_PrivateSubnet.id
  route_table_id = aws_route_table.monitor_Private_RT.id
}

#resource "aws_network_interface" "monitor_Network_Interface" {
  #subnet_id       = aws_subnet.monitor_PublicSubnet.id
  #security_groups = [aws_security_group.monitor_SG.id]

  #tags = {
    #Name = "Monitor_Network_Interface"
  #}
#}

resource "aws_network_interface" "monitor_Network_Interface_Private" {
  subnet_id       = aws_subnet.monitor_PrivateSubnet.id
  security_groups = [aws_security_group.monitor_SG.id]

  tags = {
    Name = "Monitor_Network_Interface"
  }
}

#resource "aws_network_interface_attachment" "Monitor_NI_Attachment" {
  #device_index         = 1
  #instance_id          = aws_instance.Prometheus_Node.id
  #network_interface_id = aws_network_interface.monitor_Network_Interface_Private.id

#}
