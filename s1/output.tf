output "DB-Username" {
  description = "Username used for login of database"
  value = aws_db_instance.production.username
}

output "DB-Password" {
  description = "Password used for login of database"
  value = "password123"
}

output "DB-Address" {
  description = "Address used for login of database"
  value = aws_db_instance.production.address
}

output "DB-Port" {
  description = "Port used for login of database"
  value = aws_db_instance.production.port
}

output "Public_IP" {
  description = "The public IP address assigned to the instance"
  value = aws_instance.phpmyadmin.public_ip
}


