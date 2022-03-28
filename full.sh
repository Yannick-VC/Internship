#!/bin/bash

echo "*********Install Terraform***********"

#System updates
sudo apt-get update 

#Install curl
sudo apt-get install curl -y
sudo apt-get install git -y

#gnupg install
sudo apt-get install -y gnupg software-properties-common curl

#Add Hashicorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

#Add official Hashicorp linux repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

#Update to add repo and install Terraform CLI
sudo apt-get update && sudo apt-get install terraform

#Check Terraform install
terraform -help

#Tab completion
touch ~/.bashrc
terraform -install-autocomplete

#New directory
mkdir ./learn-terraform-docker-container
cd learn-terraform-docker-container

echo "*********DOCKER*************"

#Prepare Docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install docker.io -y

#Check if Docker runs correctly
sudo docker run hello-world

echo "********TERRAFORM***********"

#Create main.tf
sudo cat > main.tf <<EOL
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}
provider "docker" {}
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
EOL

#Initialize, apply and destroy Terraform (to see if correctly installed)
sudo terraform init
sudo terraform validate
sudo terraform apply
sudo terraform destroy -lock=false
sudo docker rmi -f hello-world nginx

cd ../
sudo rm -rf learn-terraform-docker-container

echo -e "\n********GITHUB PULLS***********"
git clone https://github.com/YannickVC2/Internship

echo -e "\n*************************************"
echo "*************************************"
echo "*************************************"
echo "Your system passed the test!"
echo "*************************************"
echo "*************************************"
echo -e "*************************************\n"

read -r -p "Before continuing, enter your username for this adventure! " player

#Colors
Blue="\033[01;34m"
Red="\033[01;31m"
MainC="\033[01;37m"
ClearColor="\033[0m"

PS3="Welcome $player, make a choice in the menu: "
choices=("Scenario 1" "Scenario 2" "Help" "Quit")
select choice in "${choices[@]}"; do
	case $choice in
		"Scenario 1")
			echo -e "\nScenario 1";;
		"Scenario 2")
			echo -e "\nScenario 2";;
		"Help")
			echo -e  "\n${MainC}*******************************************************"
			echo "This interactive blue teaming experience was made by:"
			echo -e "${Blue}Yannick VC. (Cloud Intern)"
			echo -e "${Red}Alexander D. (Cloud Intern)${MainC}"
			echo -e  "*******************************************************${ClearColor}";;
		"Quit")
			read -r -p "Are you sure you want to quit? [y/n] " response
			case "$response" in 
				[yY][eE][sS]|[yY])
					exit 0;;
				*)
					;;
			esac;;
		*)
			echo "The following answer is not allowed: $REPLY";;
	esac
done
