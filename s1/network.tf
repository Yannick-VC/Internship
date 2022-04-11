#VPC
resource "aws_vpc" "main_VPC" {
  cidr_block = var.vpccidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "Main VPC"
  }
}

#Subnet 1
resource "aws_subnet" "public_Subnet_1" {
  vpc_id     = aws_vpc.main_VPC.id
  cidr_block = var.s1cidr
  availability_zone = var.az1

  tags = {
    Name = "Public Subnet 1"
  }
}


#Subnet 2
resource "aws_subnet" "public_Subnet_2" {
  vpc_id     = aws_vpc.main_VPC.id
  cidr_block = var.s2cidr
  availability_zone = var.az2

  tags = {
    Name = "Public Subnet 2"
  }
}


#Routing tables
resource "aws_route_table" "Route_Table_1" {
  vpc_id = aws_vpc.main_VPC.id

  route {
    cidr_block = var.publiccidr
    gateway_id = aws_internet_gateway.IGW.id
  }

 tags = {
    Name = "Route Table for Subnet 1"
  }
}

resource "aws_route_table" "Route_Table_2" {
  vpc_id = aws_vpc.main_VPC.id

  route {
    cidr_block = var.publiccidr
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Route Table for Subnet 2"
  }
}

#Route Table Associations 
resource "aws_route_table_association" "RTA1" {
  subnet_id      = aws_subnet.public_Subnet_1.id
  route_table_id = aws_route_table.Route_Table_1.id
}

resource "aws_route_table_association" "RTA2" {
  subnet_id      = aws_subnet.public_Subnet_2.id
  route_table_id = aws_route_table.Route_Table_2.id
}

#Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main_VPC.id

  tags = {
    Name = "Main Internet Gateway"
  }
}


#Security Groups
resource "aws_security_group" "DB_SG" {
  name        = "database_allow_ssh"
  description = "Allow ssh traffic to the database"
  vpc_id      = aws_vpc.main_VPC.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.publiccidr]
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.publiccidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.publiccidr]
  }

  tags = {
    Name = "Database allow SSH"
  }
}

resource "aws_security_group" "phpinstance" {
  name = "phpinstance"
  description = "allow for http"
  vpc_id = aws_vpc.main_VPC.id
  
  ingress {
     from_port = 80
     to_port = 80
     protocol = "tcp"
     cidr_blocks = [var.publiccidr]
  }
  egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = [var.publiccidr]
  }
 
  tags = {
     Name = "Allow HTTP"
  }
}

#Database Subnet group
resource "aws_db_subnet_group" "dbsg" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.public_Subnet_1.id, aws_subnet.public_Subnet_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

#NIC for instance
resource "aws_network_interface" "NIC" {
  subnet_id   = aws_subnet.public_Subnet_1.id
  private_ips = ["10.0.1.50"]

  tags = {
    Name = "Network Interface Card 1"
  }
}
