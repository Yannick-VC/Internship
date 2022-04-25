# AWS-Terraform

Welcome to my internship project @Deloitte Belgium as a Cyber Security Intern.

This intern project covers a training to improve the cloud skills of a clients blue team. This is done by making use
of AWS resoures that are automatically deployed by running a Terraform state of architecture (Infrastructure as Code (IaC))

The training involves the use of a realistic scenario that is deployed in the cloud that will be explained when launching the menu. For this reason it
contains both a mix of bash as well as AWS and Terraform commands.

## Installation

Before installing make sure the prerequesites are in place:
- Fresh Linux install *([Ubuntu 20.14TLS download](https://ubuntu.com/download/desktop) for a VM recommended)*
- AWS account ([How to create an AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/))
- AWS accesss key & secret ([How to get access/secret key](https://www.msp360.com/resources/blog/how-to-find-your-aws-access-key-id-and-secret-access-key/))
- Access to the repo's files

Afterwards follow the following steps:
1) **Download** the **menu.sh** file or copy paste its content in an empty file and change its execution permissions with `chmod +x menu.sh`
2) Navigate to the menu.sh file in the terminal/cmd and **execute it by inputting `sudo ./YourDirectory/menu.sh`**
3) Enter **sudo credentials**
4) Grab a cup of coffee (or whatever suits you 😀), for this **might take some time** to update/install all necessary elements on the OS
5) **Follow instructions** given by the menu

## Disclaimer

The hourly cost of deploying the training is around **€0.05-€0.10** and this training should be shut down in an appropriate manner
in order to minimize costs by destroying the deployed solution. Failing to do this will result in the resources staying up and running, costing 
extra on the monthly bill for which I hold no responsibility.

Also don't forget to have fun and share this with anyone you think might be interested in this topic!😀
