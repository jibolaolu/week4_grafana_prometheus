resource "aws_security_group" "monitor_SG" {
  vpc_id      = aws_vpc.monitor_VPC.id
  name        = "monitor_SG"
  description = "this is the SG used for both Grafana dn Prometheus"

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

  #Prometheus
  ingress {
    from_port = 9090
    protocol  = "tcp"
    to_port   = 9090
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Bastion_SG" {
  description = "This is a SG for the bastion host that connects to Prometheus in Private Subnet"
  vpc_id      = aws_vpc.monitor_VPC.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#Create a SG for instance in Private subneet that allows traffic from BH

resource "aws_security_group" "Private_Instance_SG_SSH" {
  description = "This allows only traffic from Bastion host only"
  vpc_id      = aws_vpc.monitor_VPC.id

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.Bastion_SG.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}