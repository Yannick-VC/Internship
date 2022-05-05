#NETWORK
variable "s1cidr" {
  default = "10.0.1.0/24"
  type = string
}

variable "s2cidr" {
  default = "10.0.2.0/24"
  type = string
}

variable "vpccidr" {
  default = "10.0.0.0/16"
  type = string
}

variable "az1" {
  default = "eu-west-3a"
  type = string
}

variable "az2" {
  default = "eu-west-3b"
  type = string
}

variable "publiccidr" {
  default = "0.0.0.0/0"
  type = string
}

#DATABASE
variable "username" {
  default = "root"
  type = string
}

variable "dbname" {
  default = "hr"
  type = string
}

variable "instanceclass" {
  default = "db.t2.micro"
  type = string
}
