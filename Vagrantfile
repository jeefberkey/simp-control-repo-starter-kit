# -*- mode: ruby -*-
# vi: set ft=ruby :

ENVIRONMENT   = ENV['VAGRANT_environment']
ENVIRONMENT ||= 'production'

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'
  config.vm.hostname = 'puppet'

  # config.vm.network 'forwarded_port', guest: 80, host: 8080
  # config.vm.network 'private_network', ip: '192.168.33.10'

  config.vm.synced_folder '.',
    "/etc/puppetlabs/code/environments/#{ENVIRONMENT}",
    type: 'rsync',
    rsync__exclude: ['.git/','Gemfile.lock'],
    rsync__auto: true

  config.vm.provider 'virtualbox' do |vb|  #
    vb.memory = '4608'
    vb.cpus   = '2'
  end

  config.vm.provision 'shell', inline: <<-SHELL
    sudo yum install http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    sudo curl -s https://packagecloud.io/install/repositories/simp-project/6_X_Dependencies/script.rpm.sh | bash
    sudo yum install -y vim git epel-release puppet-agent puppetserver

    sudo chown -R root.puppet /etc/puppetlabs/code/environments/#{ENVIRONMENT}
    sudo chmod -R u+rX /etc/puppetlabs/code/environments/#{ENVIRONMENT}
    # sudo chown -R puppet.puppet /etc/puppetlabs/code/environments/#{ENVIRONMENT}/simp_autofiles
  SHELL

  config.vm.provision 'shell', inline: <<-SHELL
    sudo /opt/puppetlabs/bin/puppet apply -t /etc/puppetlabs/code/#{ENVIRONMENT}/site/profiles/manifests/puppetserver.pp -e "include 'profiles::puppetserver'"

  SHELL


  config.vm.provision 'shell', inline: <<-SHELL
    # sudo /opt/puppetlabs/bin/puppet resource package r10k ensure=latest provider=puppet_gem
    # cd /etc/puppetlabs/code/environments/#{ENVIRONMENT}
    # sudo /opt/puppetlabs/puppet/bin/r10k puppetfile install

    sudo mkdir /opt/puppetlabs/puppet/cache/pserver_tmp
    # sudo /opt/puppetlabs/bin/puppet config --section=master set autosign true
    sudo /opt/puppetlabs/bin/puppet config set environment #{ENVIRONMENT}
    # sudo /opt/puppetlabs/bin/puppet resource service puppetserver ensure=running

    sudo /opt/puppetlabs/bin/puppet agent -t
  SHELL
end
