require 'rake/clean'
require 'simp/rake/pupmod/helpers'

CLEAN << 'modules'
CLEAN << 'simp_modules'
Simp::Rake::Pupmod::Helpers.new(File.dirname(__FILE__))

namespace :vagrant do
  desc 'Prepare vagrant environment'

  task :install_plugins do
    `vagrant plugin install vagrant-reload`
  end
end

namespace :puppetfile do
  desc 'Puppetfile related tasks'

  task :check do
    desc 'Check validity of Puppetfile'
    require 'r10k/action/puppetfile/check'
    puppetfile = R10K::Action::Puppetfile::Check.new({
      :root => ".",
      :moduledir => nil,
      :puppetfile => nil
      }, '')
    puppetfile.call
  end

  task :install => [:check]  do
    desc 'Run `r10k puppetfile install`'
    require 'r10k/action/puppetfile/install'
    puppetfile = R10K::Action::Puppetfile::Install.new({
      :root => '.',
      :moduledir => nil,
      :puppetfile => 'Puppetfile'
      }, '')
    puppetfile.call
  end

end
