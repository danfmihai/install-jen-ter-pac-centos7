#!/bin/bash
clear
current_user=$(whoami)
ip=$(ip a | grep eth0 | grep 'inet' | awk '{ print $2}' | head --bytes=15)

echo "Installing jenkins on Centos"
echo
sleep 2
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
clear
echo "Installing Packer"
echo
sleep 2
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer
echo 
echo "Packer installation done!"
packer --version
sleep 2
clear
echo "Instaling Terraform"
echo
sleep 2
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
    echo 'jenkins ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo > /dev/null 2>&1
else
    echo "No, the user jenkins does not exist"
fi
echo "$current_user ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR="tee -a" visudo > /dev/null 2>&1
echo "Done!"
echo "alias jen='sudo su - jenkins -s /bin/bash'" >> ~/.bashrc
echo
echo "Installed Jenkins, Packer, Terraform!"
echo
echo "To login as jenkins user type: jen"
echo "To get the admin password to setup Jenkins got to:  http://${ip}:8080 and follow the instructions."
sudo cat  /var/lib/jenkins/
source ~/.bashrc
sleep 2