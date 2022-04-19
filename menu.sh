#!/bin/bash

#: <<'END'

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

#END

echo -e "\n====================================="
echo "Your system passed the test!"
echo -e "=====================================\n"


#Username validation
read -r -p "Before continuing, enter your username! (between 4-10 characters) | " player

while :
do
if [[ ${#player} -le 3 || ${#player} -ge 11 ]]; then
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

	#Configure AWS CLI correct using aws configure

	#terraform init
	#terraform plan
	#terraform apply -auto-approve
	#clear
	#terraform output

	#Storyline
	echo -e "${bold}What is my mission?${normal}"
	echo -e "Your mission is to infiltrate the given public IP (found above), solve the challenges and hack your way through the network.\x0aNOTE: The AWS Region used for this challenge is EU-WEST-3 (Paris)"
	read -n 1 -s -r -p  $'\x0aPress any key to start!\x0a'

	###QUESTIONS###

	#/phpmyadmin
	read -r -p $'Question 1: Give the exact endpoint for which the database is hosted. (using the provided public IP)\x0a' s1a1
	if [ "$s1a1" == "/phpmyadmin" ]; then
		#password123
  		read -r -p $'Question 2: What is the password for the PHPMyAdmin?\x0a' s1a2
		if [ "$s1a2" == "password123" ]; then
			#ad-
  			read -r -p $'Question 3: What is the username of the admin account? (found somewhere in the database)\x0a' s1a3
			if [ "$s1a3" == "ad-" ]; then
				#funkymonkey
  				read -r -p $'Question 4: What is the decrypted password for this account?\x0a' s1a4
				if [ "$s1a4" == "funkymonkey" ]; then
					#Output ARN fetch
  					read -r -p $'Question 5: What is the ARN (Amazon Resource Name) for this users environment? (12 digits)\x0a' s1a5
					if [ "$s1a5" == "/" ]; then
						#AWSBackUpFullAccess
						read -r -p $'Question 6: To what services has this user any rights?\x0a' s1a6
						if [ "$s1a6" == "AWSBackUpFullAccess" ]; then
							#BackUp Plan ID
  							read -r -p $'Question 7: What is the ID for the backup?\x0a' s1a7
							if [ "$s1a7" == "/" ]; then
								echo -e "Congratulations, you reached the end! Thank you for playing $player! The scenario will close down and you will be redirected to the main menu. This may take some time so sit back and grab a coffee!"
								sleep 5
								terraform destroy -auto-approve
							fi						
						fi
					fi
				fi
			fi
		fi
	fi	
        ;;
    "2")echo "Comming soon!"
	sleep 5

        ;;
    "3")echo "Comming soon!"
	sleep 5
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
