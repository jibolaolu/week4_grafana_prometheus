resource "aws_eip" "monitor_eip" {
  vpc = true

}

#Nat-Gateway
resource "aws_nat_gateway" "monitor_nat" {
  allocation_id = aws_eip.monitor_eip.id
  subnet_id     = aws_subnet.monitor_PublicSubnet.id
  tags = {
    Name = "Monitor NAT"
  }
}

resource "aws_route_table" "NAT_route_table" {
  vpc_id = aws_vpc.monitor_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.monitor_nat.id
  }

  tags = {
    Name = "NAT-Route-Table"
  }
}

resource "aws_route_table_association" "monitor_route_private_subnet" {
  route_table_id = aws_route_table.NAT_route_table.id
  subnet_id      = aws_subnet.monitor_PrivateSubnet.id
}