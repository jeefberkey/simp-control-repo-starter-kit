# ------------------------------------------------------------------------------
# This file is used by direct rspec tests.  It is ignored by onceover, which
# generates the spec_helper.rb file for its spec matrix tests.
# ------------------------------------------------------------------------------

require 'puppetlabs_spec_helper/module_spec_helper'
require 'tmpdir'
require 'yaml'
require 'fileutils'

ctl_repo_dir = File.expand_path('..',File.dirname(__FILE__))
spec_dir     = File.dirname(__FILE__)
hiera_yaml   = File.join('..', 'hiera.yaml')
fixture_path = File.expand_path('fixtures', spec_dir)
file_utils   = FileUtils::Verbose

ALL_ENVIRONMENTS = ['production']

# read all the *.json files under spec/factsets and return a Hash
def factsets
  factsets = {}
  factset_files = Dir[File.join(File.dirname(__FILE__),'factsets','*.json')]
  factset_files.each do |file|
    fs = YAML.load_file file

    # NOTE: This data structure might change in the future,
    #   see: https://tickets.puppetlabs.com/browse/PUP-6040
    if !(fs.key?('values') && fs.key?('name'))
      warn '='*80
      warn "WARNING: Factset '#{file}' does not have the correct structure―SKIPPING."
      warn "         Was it captured using `puppet facts --environment production`?"
      warn '='*80
    else
      factset_name =  File.basename(file).sub(/\.json/,'')

      facts = fs['values'] #.reject{|k,v| k =~ /^(fact_keys|to_strip_out)$/ }

      factsets[ factset_name ] =  facts
    end
  end
  factsets
end

def environments
  # `rp_env` is the default spec-testing environment, but it's unlikely to
  # match any tiers within the control repo's hiera hierarchy.  Using it
  # can be useful to identify broken or missing default cases.
  #
  # Set the environment variable `RSPEC_PUPPET_ENVS` to pass in environments as
  # a comma-delimited list.
  envs = ENV.fetch('RSPEC_PUPPET_ENVS', 'rp_env').split(',')
  if envs.first =~ /^ALL$/
    # TODO: maybe this should check the control repo's git branches?
    ALL_PUPPET_ENVIRONMENTS
  else
    envs
  end
end

RSpec.configure do |c|
  c.default_facts = { :custom_nothing => 0 }

  ### TODO: Add JUnit output in case people want to use that?
  ### requires gem 'rspec_junit_formatter'
  ### c.add_formatter('RSpecJUnitFormatter', File.expand_path('spec.xml',spec_dir))
  c.environmentpath = File.expand_path('environments', fixture_path)
  FileUtils.mkdir_p c.environmentpath
  (environments+['production']).flatten.uniq.each do |env|
    file_utils.ln_sf(ctl_repo_dir, File.join(c.environmentpath, env))
  end

  require 'pry'; binding.pry

  c.trusted_node_data = true
  #c.manifest_dir = File.expand_path('../manifests', spec_dir)
  #c.manifest = File.join(c.manifest_dir,'site.pp')
  c.before(:suite) do
    h = YAML.load_file File.expand_path( hiera_yaml, spec_dir )
    _hiera_yaml = File.expand_path('hiera.yaml', fixture_path)
    h_ver =  h.fetch('version', 3)
    if h_ver == 3
      file_utils.cp_p(h, _hiera_yaml)
    elsif h_ver == 4
      h3 = {
        :backends => ['yaml'],
        :yaml => { :datadir => File.expand_path(h['datadir'], ctl_repo_dir) },
        :hierarchy => h['hierarchy'].map{|x| x.fetch('path',nil) || x.fetch('paths',nil)  }.flatten,
        :logger =>   'console', #or 'puppet'
      }
      File.write( _hiera_yaml,  h3.to_yaml)
      c.hiera_config = _hiera_yaml
    end

    Puppet.debug=true
    Puppet::Util::Log.level = :debug
    Puppet::Util::Log.newdestination(:console)
  end

  c.before(:each) do
    Puppet.debug=true
    Puppet::Util::Log.level = :debug
    Puppet::Util::Log.newdestination(:console)
  end

end

# Fail on broken symlinks to module fixtures
Dir.glob("#{RSpec.configuration.module_path}/*").each do |dir|
  begin
    Pathname.new(dir).realpath
  rescue
    fail "ERROR: The module '#{dir}' is not installed. Tests cannot continue."
  end
end

