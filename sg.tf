resource "aws_security_group" "monitor_Public" {
  vpc_id      = aws_vpc.monitor_VPC.id
  name        = "Public Instances"
  description = "this is the SG for Public instances"

  #ssh port
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  #grafana
  ingress {
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Public Security Group"
  }
}

resource "aws_security_group" "Private_Instances" {
  vpc_id      = aws_vpc.monitor_VPC.id
  description = "This is for Instances in the Private Subnet"

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    cidr_blocks     = ["10.8.2.0/24"]
    security_groups = [aws_security_group.monitor_Public.id]
  }
  ingress {
    from_port   = 9090
    protocol    = "tcp"
    to_port     = 9090
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Private Security Group"
  }


}
#resource "aws_security_group" "Bastion_SG" {
#description = "This is a SG for the bastion host that connects to Prometheus in Private Subnet"
#vpc_id      = aws_vpc.monitor_VPC.id

# ingress {
# from_port   = 22
# protocol    = "tcp"
# to_port     = 22
# cidr_blocks = ["0.0.0.0/0"]
# }

# egress {
# from_port   = 0
# protocol    = "-1"
# to_port     = 0
#cidr_blocks = ["0.0.0.0/0"]
# }

#}

#Create a SG for instance in Private subneet that allows traffic from BH

#resource "aws_security_group" "Private_Instance_SG_SSH" {
#description = "This allows only traffic from Bastion host only"
#vpc_id      = aws_vpc.monitor_VPC.id

#ingress {
#from_port       = 22
#protocol        = "tcp"
#to_port         = 22
#security_groups = [aws_security_group.Bastion_SG.id]
#cidr_blocks = ["0.0.0.0/0"]
#}

#egress {
#from_port   = 0
# protocol    = "-1"
#to_port     = 0
#cidr_blocks = ["0.0.0.0/0"]
# }

#}