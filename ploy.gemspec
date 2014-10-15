lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ploy/version'

Gem::Specification.new do |s|
  s.name = 'ploy'
  s.version = Ploy::VERSION
  s.date = '2013-07-14'
  s.summary = 'Multi-phase deployment tool'
  s.description = 'Multi-phase deployment tool for use in a continuous deployment environment.'
  s.authors = ["Michael Bruce"]
  s.email = ['mbruce@manta.com']
  
  s.files += Dir['lib/**/*.rb']
  s.test_files += Dir['spec/**/*_spec.rb']
  s.executables << 'ploy'
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'aws-sdk'
  s.add_runtime_dependency 'fpm'
  s.add_runtime_dependency 'sinatra'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-given'
  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10.0'
end
