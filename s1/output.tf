output "Public_IP" {
  description = "The public IP address assigned to the instance"
  value = aws_instance.phpmyadmin.public_ip
}


