resource "aws_instance" "phpmyadmin" {
  ami             = "ami-0c6ebbd55ab05f070"
  instance_type   = "t2.micro"
  user_data = data.template_file.init.rendered
  vpc_security_group_ids = [aws_security_group.phpinstance.id] 
  subnet_id = aws_subnet.public_Subnet_1.id
  associate_public_ip_address = true
  tags = {
    Name = "PHPMyAdminInstance"
  }
}

data "template_file" "init" {
  template = "${file("./util/file.sh.tpl")}"
  vars = {
    db_username = aws_db_instance.database.username
    db_password = aws_db_instance.database.password
    db_address = aws_db_instance.database.address
  }
}
