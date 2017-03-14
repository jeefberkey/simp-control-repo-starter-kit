# -*- mode: ruby -*-
# vi: set ft=ruby :

if ENV['VAGRANT_environment']
  @environment = ENV['VAGRANT_environment']
else
  @environment = 'production'
end

Vagrant.configure("2") do |config|
  config.vm.box = 'centos/7'
  config.vm.hostname = 'puppet'

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder '.',
    "/etc/puppetlabs/code/environments/#{@environment}",
    type: 'rsync',
    rsync__exclude: ['.git/','Gemfile.lock'],
    rsync__auto: true

  config.vm.provider "virtualbox" do |vb|  #
    vb.memory = "4608"
    vb.cpus   = "2"
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo yum install http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    sudo curl -s https://packagecloud.io/install/repositories/simp-project/6_X_Dependencies/script.rpm.sh | bash
    sudo yum install -y vim git epel-release puppet-agent puppetserver
    sudo chown -R root.puppet /etc/puppetlabs/code/environments/#{@environment}
    sudo chmod -R u+rX /etc/puppetlabs/code/environments/#{@environment}
    sudo chown -R puppet.puppet /etc/puppetlabs/code/environments/#{@environment}/simp_autofiles

    # sudo /opt/puppetlabs/bin/puppet resource package r10k ensure=latest provider=puppet_gem
    # cd /etc/puppetlabs/code/environments/#{@environment}
    # sudo /opt/puppetlabs/puppet/bin/r10k puppetfile install

    sudo mkdir /opt/puppetlabs/puppet/cache/pserver_tmp
    sudo /opt/puppetlabs/bin/puppet config --section=master set autosign true
    sudo /opt/puppetlabs/bin/puppet config set autosign true
    sudo /opt/puppetlabs/bin/puppet config set environment #{@environment}
    sudo /opt/puppetlabs/bin/puppet resource service puppetserver ensure=running

    sudo /opt/puppetlabs/bin/puppet agent -t
  SHELL
end
