# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
yum -y install epel-release
yum install jq make unzip ntpdate openssl-devel gcc python-devel python-pip -y

cd /usr/src
wget --quiet https://releases.hashicorp.com/terraform/0.7.13/terraform_0.7.13_linux_amd64.zip
wget --quiet https://releases.hashicorp.com/packer/0.12.0/packer_0.12.0_linux_amd64.zip
unzip terraform_0.7.13_linux_amd64.zip
unzip packer_0.12.0_linux_amd64.zip
mv terraform /usr/bin/
mv packer /usr/bin/

pip install -U pip
pip install urllib3[secure]
pip install awscli
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/centos-7.1"
  config.vm.hostname = "mikado"

  config.vm.provision "initial-setup", type: "shell", inline: $script
  config.vm.synced_folder '.', '/home/vagrant/mikado'

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
    v.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
  end
end
