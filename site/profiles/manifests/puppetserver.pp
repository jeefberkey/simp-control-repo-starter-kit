# Set up a puppetserver
class profiles::puppetserver {
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

}
