# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
UBUNTUVERSION = "16.04"
CPUCOUNT = "2"
RAM = "4096"

$script = <<SCRIPT
export DEBIAN_PRIORITY=critical
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
APT_OPTS="--assume-yes --no-install-suggests --no-install-recommends -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\""
echo "Upgrading packages ..."
apt-get update ${APT_OPTS} >/dev/null 2>&1
apt-get upgrade ${APT_OPTS} >/dev/null 2>&1
echo "Installing prerequisites ..."
apt-get install ${APT_OPTS} \
  build-essential \
  curl \
  zip \
  dialog \
  jq \
  unzip \
  python-pip \
  python-setuptools \
  python3-pip \
  python3-setuptools \
  >/dev/null

cd /usr/src
echo "Downloading terraform and packer ..."
wget --quiet https://releases.hashicorp.com/terraform/0.8.0/terraform_0.8.0_linux_amd64.zip
wget --quiet https://releases.hashicorp.com/packer/0.12.0/packer_0.12.0_linux_amd64.zip
echo "Installing terraform and packer ..."
unzip terraform_0.8.0_linux_amd64.zip >/dev/null
unzip packer_0.12.0_linux_amd64.zip >/dev/null
mv terraform /usr/bin/
mv packer /usr/bin/

echo "Installing python dependencies for the installer ..."
pip install urllib3[secure] awscli >/dev/null 2>&1
pip3 install pythondialog pyyaml >/dev/null 2>&1

# this is a workaround for the dialog bug
echo 'export TERM=xterm' >> /home/vagrant/.bashrc
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/ubuntu-#{UBUNTUVERSION}"
  config.vm.hostname = "mikado"

  config.vm.provision "prepare-shell", type: "shell", inline: "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile", privileged: false
  config.vm.provision "initial-setup", type: "shell", inline: $script
  config.vm.synced_folder '.', '/home/vagrant/mikado'

  config.vm.provider "virtualbox" do |v|
    v.memory = "#{RAM}"
    v.cpus = "#{CPUCOUNT}"
  end

  config.vm.provider "docker" do |v, override|
    override.vm.box = "tknerr/baseimage-ubuntu-#{UBUNTUVERSION}"
  end

  ["vmware_fusion", "vmware_workstation"].each do |p|
    config.vm.provider p do |v|
      v.vmx["memsize"] = "#{RAM}"
      v.vmx["numvcpus"] = "#{CPUCOUNT}"
    end
  end


  config.vm.provider "parallels" do |prl|
    prl.memory = "#{RAM}"
    prl.cpus = "#{CPUCOUNT}"
  end
end
