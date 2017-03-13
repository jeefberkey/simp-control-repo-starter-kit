# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder '.',
    '/etc/puppetlabs/code/environments/vagrant',
    type: 'rsync',
    rsync__exclude: ".git/"

  config.vm.provider "virtualbox" do |vb|  #
    vb.memory = "4608"
    vb.cpus   = "2"
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo yum install http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    sudo curl -s https://packagecloud.io/install/repositories/simp-project/6_X_Dependencies/script.rpm.sh | bash
    sudo yum install -y vim git epel-release puppet-agent
  SHELL
end
