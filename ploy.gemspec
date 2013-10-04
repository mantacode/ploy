Gem::Specification.new do |s|
  s.name = 'ploy'
  s.version = '0.0.1'
  s.date = '2013-03-10'
  s.summary = 'deployment'
  s.description = 'deployment'
  s.authors = ["Michael Bruce"]
  s.email = 'mbruce@manta.com'
  s.files = [
    'lib/cli.rb',
    'lib/publisher.rb',
    'lib/installer.rb',
    'lib/common.rb'
  ]
  s.add_runtime_dependency 'aws-sdk'
  s.add_runtime_dependency 'fpm'
  s.executables << 'ploy'
end
