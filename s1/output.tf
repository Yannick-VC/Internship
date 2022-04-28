output "Public_IP" {
  description = "The public IP address assigned to the instance"
  value = aws_instance.phpmyadmin.public_ip
}

output "Account ID" {
  description = "The account ID needed to log into the AWS account"
  value = aws_vpc.main_VPC.owner_id
}
