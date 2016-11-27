# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
yum -y install epel-release
yum update -y
yum install jq make unzip ntpdate -y
service ntpdate restart
pip install awscli

cd /usr/src
wget https://releases.hashicorp.com/terraform/0.7.12/terraform_0.7.12_linux_amd64.zip
wget https://releases.hashicorp.com/packer/0.12.0/packer_0.12.0_linux_amd64.zip
unzip terraform_0.7.12_linux_amd64.zip
unzip packer_0.12.0_linux_amd64.zip
mv terraform /usr/bin/
mv packer /usr/bin/

easy_install pip
pip install awscli
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/centos-7.1"
  config.vm.box_version = ">= 2.2.2"
  config.vm.hostname = "mikado"

  config.vm.provision "initial-setup", type: "shell", inline: $script
  config.vm.synced_folder '.', '/home/vagrant/mikado'

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
    v.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
  end
end
