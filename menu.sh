#!/bin/bash

#System updates
sudo apt-get update

#Add official Hashicorp linux repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
#Add Hashicorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

#Install curl, git, awscli, gnupg, docker, terraform
sudo apt-get install curl git awscli gnupg software-properties-common docker.io terraform -y
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

#Check Terraform install
terraform -help

#Tab completion for TF
touch ~/.bashrc
terraform -install-autocomplete

#New directory
mkdir ./learn-terraform-docker-container
cd learn-terraform-docker-container

#Docker

#Prepare Docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install docker.io -y

#Check if Docker runs correctly
sudo docker run hello-world

#Terraform

#Create main.tf for test run
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

#Initialize, apply and destroy Terraform (check correct install)
sudo terraform init
sudo terraform validate
sudo terraform apply -auto-approve
sudo terraform destroy -lock=false -auto-approve
sudo docker rmi -f hello-world nginx

cd ../
sudo rm -rf learn-terraform-docker-container

#Git Clone
git clone https://github.com/YannickVC2/Internship

echo -e "\n====================================="
echo "Your system passed the test!"
echo -e "=====================================\n"


#Username validation
read -r -p "Before continuing, enter your username! (between 4-10 characters) | " player

while : 
do
if [[ ${#player} -ge 11 || ${#player} -le 3 ]]; then
echo -e "Given username contains ${#player} character(s), re-enter your username (between 4-10 characters)"
read -r -p "" player
else break 
fi 
done

#Styling
Blue="\033[01;34m"
Red="\033[01;31m"
MainC="\033[01;37m"
ClearColor="\033[0m"
bold=`tput bold`
normal=`tput sgr0`

#Playing menu
while : 
do
clear
cat<<EOF
=============================================
| Cyber Cloud Internship                    |
|------------------------------------------ |
| Hello, $player, please make a choise:
|                                           |
| Play scenario 1 (1)                       |
| Play scenario 2 (2)                       |
| How to play     (3)                       |
| Credits         (4)                       |
| Quit the game   (5)                       |
---------------------------------------------
EOF

#Player choises with all other code
read -n1 -s 
case "$REPLY" in
    "1")echo -e "${bold}$player${normal}, scenario 1 will be set up for you. This can take up to 10 minutes so grab a coffee and wait untill you see the Public_IP output at the bottom!\x0a"

        cd ./s1/
        #terraform init
        #terraform plan
        #terraform apply -auto-approve

        #Storyline
        echo -e "${bold}What is my mission?${normal}"
        echo -e "Your mission is to infiltrate the database (IP will be given later on), find a way to perform privillege escalation and\x0abreak into the backup databaselocated on a different subnet"
        read -n 1 -s -r -p  $'\x0aPress any key to continue\x0a'

        #Questions 1
        read -r -p $'Question 1: What is the password to the PHPMyAdmin login page?\x0a' s1a1

        #Question 2
        read -r -p $'Question 2: Which backup was compromised in the logging database? (format = DD/MM/YYYY)\x0a' s1a2

        #Question 3
        read -r -p $'Question 3: \x0a' s1a3

        echo -e "Thank you for playing our game $player! Let me put you back to the main menu."
        sleep 5
        ;;
    "2")echo "Comming soon!"
        sleep 5
        ;;
    "3")echo "Comming soon!"
        ;;
    "4")echo -e  "\n${MainC}---------------------------------------------------------"
        echo "| This interactive blue teaming experience was made by: |"
        echo -e "| ${Blue}Yannick VC. (Cloud Intern)${MainC}                            |"
        echo -e "| ${Red}Alexander D. (Cloud Intern)${MainC}                           |"
        echo -e  "---------------------------------------------------------${ClearColor}"
        sleep 5
        ;;
    "5")exit;;
     * )echo "invalid option"
        sleep 1
        ;;
    esac
done
