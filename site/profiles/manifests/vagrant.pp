#
class profiles::vagrant {
  # Maintain connection to the VM
  pam::access::rule { 'vagrant_all':
    users      => ['vagrant'],
    permission => '+',
    origins    => ['ALL'],
  }
  sudo::user_specification { 'vagrant':
    user_list => ['vagrant'],
    cmnd      => ['ALL'],
    passwd    => false,
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

  package { 'epel-release': ensure => latest }
  package { 'tree':         ensure => latest }
  package { 'jq':           ensure => latest }
}
