# Set up a puppetserver
class profiles::puppetserver_bootstrap {
  class { 'pupmod::master':
    firewall     => true,
    trusted_nets => ['ALL'],
  }
  exec { 'set autosign':
    command => '/opt/puppetlabs/bin/puppet config --section master set autosign true',
    unless  => '/opt/puppetlabs/bin/puppet config --section master print autosign | grep true',
  }
  file {
    default:
      owner => 'puppet',
      group => 'puppet';
    '/var/log/puppetlabs/puppetserver':;
    '/var/run/puppetlabs/puppetserver':;
  }
  sshd_config { 'PermitRootLogin'    : value => 'yes' }
  sshd_config { 'AuthorizedKeysFile' : value => '.ssh/authorized_keys' }
  include 'tcpwrappers'
  include 'iptables'
  tcpwrappers::allow { 'sshd': pattern => 'ALL' }
  iptables::listen::tcp_stateful { 'allow_ssh':
    trusted_nets => ['ALL'],
    dports       => 22,
  }
}
