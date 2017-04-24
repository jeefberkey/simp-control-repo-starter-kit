#
class profiles::vagrant {
  # Maintain connection to the VM
  pam::access::rule { 'vagrant':
    users      => ['vagrant'],
    permission => '+',
    origins    => ['ALL'],
  }
  sudo::user_specification { 'vagrant_root_all':
    user_list => ['vagrant','root'],
    cmnd      => ['ALL'],
    passwd    => false,
  }

  package { 'epel-release': ensure => latest }
  package { 'tree':         ensure => latest }
  package { 'jq':           ensure => latest }
}
