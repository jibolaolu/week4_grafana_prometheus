resource "aws_instance" "Grafana_Node" {
  ami             = "ami-0f7865f0b7b26ca0c"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.monitor_PublicSubnet.id
  security_groups = [aws_security_group.monitor_SG.id]
  user_data       = file("grafana.sh")
  key_name        = "LinuxKeyPair"

  tags = {
    Name = "Grafana_Node"
  }
}

resource "aws_instance" "Prometheus_Node" {
  ami             = "ami-045613b175c84340c"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.monitor_PrivateSubnet.id
  security_groups = [aws_security_group.monitor_SG.id, aws_security_group.Private_Instance_SG_SSH.id]
  user_data       = file("prometheus.sh")
  key_name        = "LinuxKeyPair"

  tags = {
    Name = "Prometheus_Node"
  }
}

resource "aws_instance" "monitor_BH" {
  ami             = "ami-0120edc7e99bf66d7"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.monitor_PublicSubnet.id
  key_name        = "LinuxKeyPair"
  security_groups = [aws_security_group.Bastion_SG.id]

  tags = {
    Name = "Monitor_BH"
  }
}
