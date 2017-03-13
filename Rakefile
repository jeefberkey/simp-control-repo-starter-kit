require 'simp/rake/pupmod/helpers'

Simp::Rake::Pupmod::Helpers.new(File.dirname(__FILE__))

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

  task :install do
    desc 'Run `r10k puppetfile install`'
    require 'r10k/action/puppetfile/install'
    Rake::Task["puppetfile:check"].execute
    puppetfile = R10K::Action::Puppetfile::Install.new({
      :root => ".",
      :moduledir => nil,
      :puppetfile => 'Puppetfile'
      }, '')
    puppetfile.call
  end

  task :puppetfile_clean do
    desc 'Empty the modules directory'
    FileUtils.rm_rf(Dir.glob('modules/**'))
  end
end
