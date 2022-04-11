resource "aws_db_instance" "database" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.instanceclass
  db_name              = var.dbname
  username             = var.username
  password             = "password123"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible = true

  db_subnet_group_name = aws_db_subnet_group.dbsg.id
  vpc_security_group_ids = [aws_security_group.DB_SG.id]
  
  provisioner "local-exec" {
     command = "mysql -h ${aws_db_instance.database.address} -u ${aws_db_instance.database.username} --password=${aws_db_instance.database.password} ${aws_db_instance.database.db_name} < ./util/users.sql"
  }
}
