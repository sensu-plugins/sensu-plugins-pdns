lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require_relative 'lib/sensu-plugins-pdns'

Gem::Specification.new do |s|
  s.name                   = 'sensu-plugins-pdns'
  s.version                = SensuPluginsPdns::Version::VER_STRING
  s.platform               = Gem::Platform::RUBY
  s.authors                = ['Hammad Shah']
  s.date                   = Date.today.to_s
  s.email                  = ['haashah@gmail.com']
  s.homepage               = 'https://github.com/sensu-plugins/sensu-plugins-pdns'
  s.summary                = 'Sensu Plugins for PowerDNS metrics'
  s.description            = 'Sensu plugin for monitoring + metrics collection of
                             PowerDNS recursor statistics'
  s.metadata               = { 'maintainer'         => '@haashah',
                               'development_status' => 'active',
                               'production_status'  => 'unstable - testing recommended' }
  s.license                = 'MIT'
  s.has_rdoc               = false
  s.require_paths          = ['lib']
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)
  s.required_ruby_version  = '>= 2.0.0'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})

  s.add_runtime_dependency 'sensu-plugin', '~> 1.2'

  s.add_development_dependency 'bundler',                   '~> 1.7'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  s.add_development_dependency 'github-markup',             '~> 1.3'
  s.add_development_dependency 'pry',                       '~> 0.10'
  s.add_development_dependency 'rake',                      '~> 10.0'
  s.add_development_dependency 'redcarpet',                 '~> 3.2'
  s.add_development_dependency 'rubocop',                   '~> 0.40.0'
  s.add_development_dependency 'rspec',                     '~> 3.1'
  s.add_development_dependency 'yard',                      '~> 0.8'
end
