# -*- mode: ruby -*-
# vi: set ft=ruby :

def environment
  penv = ENV['VAGRANT_environment']
  penv ||= 'production'
end

deps_and_repos = <<-EOF
  sudo yum install http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
  sudo curl -s https://packagecloud.io/install/repositories/simp-project/6_X_Dependencies/script.rpm.sh | bash
  sudo yum install -y vim git epel-release puppet-agent puppetserver
EOF

bootstrap_puppetserver = <<-EOF
  sudo chown -R root.puppet /etc/puppetlabs/code/environments/#{environment}
  sudo chmod -R u+rX /etc/puppetlabs/code/environments/#{environment}
  sudo chown puppet.puppet /var/log/puppetlabs/puppetserver
  sudo chown puppet.puppet /var/run/puppetlabs/puppetserver
  mkdir -p /opt/puppetlabs/puppet/cache/pserver_tmp
  sudo /opt/puppetlabs/bin/puppet apply -t /etc/puppetlabs/code/#{environment}/site/profiles/manifests/puppetserver_bootstrap.pp -e "include 'profiles::puppetserver_bootstrap','profiles::vagrant','simp::puppetdb'"
  sudo /opt/puppetlabs/bin/puppet apply -t /etc/puppetlabs/code/#{environment}/site/profiles/manifests/puppetserver_bootstrap.pp -e "include 'profiles::puppetserver_bootstrap','profiles::vagrant','simp::puppetdb'"
  true
EOF

generate_keydist = <<-EOF
  cd /etc/puppetlabs/code/environments/production/utils/FakeCA; KEYDIST_DIR=/var/simp/environments/#{environment}/site_files/pki_files/files/keydist /etc/puppetlabs/code/environments/production/utils/FakeCA/gencerts_nopass.sh auto `puppet facts | jq -r .values.fqdn`; true
EOF

run_puppet = <<-EOF
  /opt/puppetlabs/bin/puppet config set environment #{environment}
  /opt/puppetlabs/bin/puppet resource service puppetserver ensure=running

  /opt/puppetlabs/bin/puppet agent -t
  /opt/puppetlabs/bin/puppet agent -t
  /opt/puppetlabs/bin/puppet agent -t
EOF

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'
  config.vm.hostname = 'puppet'

  # config.vm.network 'forwarded_port', guest: 80, host: 8080
  # config.vm.network 'private_network', ip: '192.168.33.10'

  config.vm.synced_folder '.',
    "/etc/puppetlabs/code/environments/#{environment}",
    type: 'rsync',
    rsync__exclude: ['.git/','dist/','Gemfile.lock'],
    rsync__auto: true

  config.vm.provider 'virtualbox' do |vb|  #
    vb.memory = '4608'
    vb.cpus   = '2'
  end

  config.vm.provision 'shell', name: 'Deps and repos', inline: deps_and_repos
  config.vm.provision 'shell', name: 'Bootstrap Puppetserver', inline: bootstrap_puppetserver, keep_color: true
  config.vm.provision 'shell', name: 'Keydist', inline: generate_keydist
  config.vm.provision 'shell', name: 'Run Puppet', inline: run_puppet, keep_color: true
  config.vm.provision :reload, name: 'Apply kernel params'
  config.vm.provision 'shell', name: 'Run Puppet', inline: run_puppet, keep_color: true

end
