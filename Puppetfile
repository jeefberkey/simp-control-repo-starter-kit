forge "http://forge.puppetlabs.com"


# Load SIMP modules
moduledir 'simp_modules'
eval (File.read(File.expand_path( './Puppetfile.simp' )))

# Load the rest of the site modules
moduledir 'modules'


# Modules from the Puppet Forge
# Versions should be updated to be the latest at the time you start
#mod "puppetlabs/inifile",     '1.5.0'
#mod "puppetlabs/stdlib",      '4.11.0'
mod "puppetlabs/concat",      '2.1.0'

# Modules from Git
# Examples: https://github.com/puppetlabs/r10k/blob/master/doc/puppetfile.mkd#examples
mod 'virtualbox',
  :git    => 'https://github.com/voxpupuli/puppet-virtualbox.git',
  :ref    => 'v1.8.0'

