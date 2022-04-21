#!/bin/bash

#: <<'END'

#System updates
sudo apt-get update

#Install curl, git, awscli, gnupg, docker, terraform
sudo apt-get install curl git awscli gnupg software-properties-common docker.io terraform -y

#Add official Hashicorp linux repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
#Add Hashicorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -


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
Green="\033[01;32m"
MainC="\033[01;37m"
ClearColor="\033[0m"
Bold=$(tput bold)
Normal=$(tput sgr0)

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
| Play            (1)                       |
| How to play     (2)                       |
| Credits         (3)                       |
| Quit            (4)                       |
---------------------------------------------
EOF

#Player choises with all other code
read -n1 -s
case "$REPLY" in
    "1")echo -e "${Bold}$player${Normal}, the scenario will be set up for you. This can take up to 10 minutes so grab a coffee and wait untill you see the Public_IP output at the bottom!\x0a"

        cd ./s1/

	#Configure AWS CLI correct using aws configure
	aws configure

	terraform init
	terraform plan
	terraform apply -auto-approve
	clear
	terraform output

	#Storyline
	echo -e "${Bold}What is my mission?${Normal}"
	echo -e "Your mission is to infiltrate the given public IP (found above), solve the challenges and hack your way through the network.\x0aNOTE: The AWS Region used for this challenge is EU-WEST-3 (Paris)"
	read -n 1 -s -r -p  $'\x0aPress any key to start!\x0a'

	###QUESTIONS###

	#/phpmyadmin
	MAX_TRIES="35"
	TRIES="0"
	REMAINING="35"
	read -r -p $'Question 1: Give the exact endpoint for which the database is hosted. (using the provided public IP)\x0a' s1a1
	while [ "$s1a1" != "/phpmyadmin" ]; do
		if [ "$REMAINING" -le "0" ]; then
			echo "You've gotten to many wrong answers (we might think you're brute forcing the answers). The game will shut down now."
			sleep 5
			terraform destroy -auto-approve
			exit
		else
			TRIES=$(expr $TRIES + 1)
			REMAINING=$(expr $MAX_TRIES - $TRIES)
			echo -e "\x0a${Red}WRONG${ClearColor}, $REMAINING guesse(s) remaining."
			read -r -p $'Question 1: Give the exact endpoint for which the database is hosted. (using the provided public IP)\x0a' s1a1
		fi
	done
	echo -e "${Green}CORRECT!${ClearColor}\x0a"

	read -r -p $'Question 2: What is the password for the PHPMyAdmin?\x0a' s1a2
	while [ "$s1a2" != "password123" ]; do
		if [ "$REMAINING" -le "0" ]; then
			echo "You've gotten to many wrong answers (we might think you're brute forcing the answers). The game will shut down now."
			sleep 5
			terraform destroy -auto-approve
			exit
		else
			TRIES=$(expr $TRIES + 1)
			REMAINING=$(expr $MAX_TRIES - $TRIES)
			echo -e "\x0a${Red}WRONG${ClearColor}, $REMAINING guesse(s) remaining."
			read -r -p $'Question 2: What is the password for the PHPMyAdmin?\x0a' s1a2
		fi
	done
	echo -e "${Green}CORRECT!${ClearColor}\x0a"

	read -r -p $'Question 3: What is the username of the admin account? (found somewhere in the database)\x0a' s1a3
	while [ "$s1a3" != "ad-" ] ; do
		if [ "$REMAINING" -le "0" ]; then
			echo "You've gotten to many wrong answers (we might think you're brute forcing the answers). The game will shut down now."
			sleep 5
			terraform destroy -auto-approve
			exit
		else
			TRIES=$(expr $TRIES + 1)
			REMAINING=$(expr $MAX_TRIES - $TRIES)
			echo -e "\x0a${Red}WRONG${ClearColor}, $REMAINING guesse(s) remaining."
			read -r -p $'Question 3: What is the username of the admin account? (found somewhere in the database)\x0a' s1a3
		fi
	done
	echo -e "${Green}CORRECT!${ClearColor}\x0a"

	read -r -p $'Question 4: What is the decrypted password for this account?\x0a' s1a4
	while [ "$s1a4" != "funkymonkey" ]; do
		if [ "$REMAINING" -le "0" ]; then
			echo "You've gotten to many wrong answers (we might think you're brute forcing the answers). The game will shut down now."
			sleep 5
			terraform destroy -auto-approve
			exit
		else
			TRIES=$(expr $TRIES + 1)
			REMAINING=$(expr $MAX_TRIES - $TRIES)
			echo -e "\x0a${Red}WRONG${ClearColor}, $REMAINING guesse(s) remaining."
			read -r -p $'Question 4: What is the decrypted password for this account?\x0a' s1a4
		fi
	done
	echo -e "${Green}CORRECT!${ClearColor}\x0a"

	read -r -p $'Question 5: What is the ARN (Amazon Resource Name) for this users environment? (12 digits)\x0a' s1a5
	while [ "$s1a5" != "/" ]; do
		if [ "$REMAINING" -le "0" ]; then
			echo "You've gotten to many wrong answers (we might think you're brute forcing the answers). The game will shut down now."
			sleep 5
			terraform destroy -auto-approve
			exit
		else
			TRIES=$(expr $TRIES + 1)
			REMAINING=$(expr $MAX_TRIES - $TRIES)
			echo -e "\x0a${Red}WRONG${ClearColor}, $REMAINING guesse(s) remaining."
			read -r -p $'Question 5: What is the ARN (Amazon Resource Name) for this users environment? (12 digits)\x0a' s1a5
		fi
	done
	echo -e "${Green}CORRECT!${ClearColor}\x0a"

	read -r -p $'Question 6: To what services has this user any rights?\x0a' s1a6
	while [ "$s1a6" != "AWSBackUpFullAccess" ]; do
		if [ "$REMAINING" -le "0" ]; then
			echo "You've gotten to many wrong answers (we might think you're brute forcing the answers). The game will shut down now."
			sleep 5
			terraform destroy -auto-approve
			exit
		else
			TRIES=$(expr $TRIES + 1)
			REMAINING=$(expr $MAX_TRIES - $TRIES)
			echo -e "\x0a${Red}WRONG${ClearColor}, $REMAINING guesse(s) remaining."
			read -r -p $'Question 6: To what services has this user any rights?\x0a' s1a6
		fi
	done
	echo -e "${Green}CORRECT!${ClearColor}\x0a"

	read -r -p $'Question 7: What is the ID for the backup?\x0a' s1a7
	while [ "$s1a7" != "/" ]; do
		if [ "$REMAINING" -le "0" ]; then
			echo "You've gotten to many wrong answers (we might think you're brute forcing the answers). The game will shut down now."
			sleep 5
			terraform destroy -auto-approve
			exit
		else
			TRIES=$(expr $TRIES + 1)
			REMAINING=$(expr $MAX_TRIES - $TRIES)
			echo -e "\x0a${Red}WRONG${ClearColor}, $REMAINING guesse(s) remaining."
			read -r -p $'Question 7: What is the ID for the backup?\x0a' s1a7
		fi
	done
	echo -e "${Green}CORRECT!${ClearColor}\x0a"

	echo -e "Congratulations, you reached the end! Thank you for playing $player! The scenario will close down and you will be redirected to the main menu.\x0aThis may take some time so sit back and grab a coffee!"
	sleep 7
	terraform destroy -auto-approve
        ;;
    "2")cat <<EOF
${Bold}How many people can play this game?${Normal}
This game is designed to be a single-player game but can be deployed on 1 VM and everyone
can brainstorm together and come up with ways to tackle the scenario.

${Bold}What is the aim of the game?${Normal}
The aim of the game is to hack your way through several AWS resources ranging from databases
to webservers to IAM systems etc. whilst answering questions (like a Capture The Flag (CTF) game).

${Bold}How do I start a scenario?${Normal}
When you are ready to tackle the challenge, press '1' to play the scenario.

${Bold}How do I quit the game?${Normal}
If you wish to quit the game, without having started a challenge or at the end of one, simply press '4' to quit the application.

${Bold}What if, whilst playing the game, I try to quit the game?${Normal}
In this case there are 2 options:
	- Exhaust your guesses (wrongly answer the questions) until you have no guesses left and the game will terminate itself.
	- Force quit the game which will let the resources live and exist. Afterwards you have to manually go into
 	  folder of the scenario and type 'terraform destroy -auto-approve' and wait till there is a green box saying "x resources destroyed".

${Bold}Things to note:${Normal}
	- Answers must be given with respect to upper and lowercase. (e.g. "FooBar" is not the same as "foobar")
	- The player has a total of 35 guesses spread over 7 questions. (so that a player can have 5 guesses per question)
	- The games must be played on a completely new Linux VM. (to avoid the installed and configured items from not working as intend)
	- You must have fun whilst playing ;)
EOF

	read -n 1 -s -r -p  $'\x0aPress any key to return to the main menu!\x0a'
	#sleep 5
        ;;
    "3")echo -e  "\x0a${MainC}---------------------------------------------------------"
        echo "| This interactive blue teaming experience was made by: |"
        echo -e "| ${Blue}Yannick VC. (Cloud Intern)${MainC}                            |"
        echo -e "| ${Red}Alexander D. (Cloud Intern)${MainC}                           |"
        echo -e  "---------------------------------------------------------${ClearColor}"
        sleep 10
        ;;
    "4")exit 0;;
     * )echo "Invalid option"
        sleep 0.3
        ;;
    esac
done
