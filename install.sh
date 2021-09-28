#!/bin/bash
clear
current_user=$(whoami)

echo "Installing jenkins on Centos"

sudo yum install -y wget curl git unzip
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y && sudo yum install epel-release java-11-openjdk-devel -y
sudo yum install jenkins -y
sudo systemctl daemon-reload
echo
echo "Jenkins Installation done!"
echo
sleep 2
echo "Installing Packer"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer
echo 
echo "Packer installation done!"
packer --version
sleep 2
echo "Instaling Terraform"
echo
wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip
unzip terraform_*
sudo mv terraform* /bin
echo "Terraform installation done!"
terraform version
echo 
echo
sleep 2

# testing if user jenkins exists
echo "Adding users to sudoers:"
if getent passwd jenkins > /dev/null 2>&1; then
    echo 'jenkins ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo
else
    echo "No, the user does not exist"
fi
echo "$current_user ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR="tee -a" visudo

echo "alias jen='sudo su - jenkins -s /bin/bash'" >> ~/.bashrc
source ~/.bashrc
echo
echo "Installed jenkins,packer,terraform!"
echo
echo "To login as jenkins user type: jen"
echo
sleep 2