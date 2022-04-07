resource "aws_instance" "phpmyadmin" {
  ami             = "ami-0c6ebbd55ab05f070"
  instance_type   = "t2.micro"
  #user_data	= file("./util/file.sh")
  user_data = data.template_file.init.rendered
  security_groups = [aws_security_group.default_SG.name] 
 
  associate_public_ip_address = true

  tags = {
    Name = "PHPMyAdminInstance"
  }
}

resource "aws_security_group" "default_SG" {
  name        = "allow_all"
  description = "Allow all inbound http(s) traffic"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

data "template_file" "init" {
  template = "${file("./util/file.sh.tpl")}"
  vars = {
    db_username = aws_db_instance.production.username
    db_password = aws_db_instance.production.password
    db_address = aws_db_instance.production.address
  }
}
