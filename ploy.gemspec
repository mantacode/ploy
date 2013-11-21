Gem::Specification.new do |s|
  s.name = 'ploy'
  s.version = '0.0.11'
  s.date = '2013-10-25'
  s.summary = 'Multi-phase deployment tool'
  s.description = 'Multi-phase deployment tool for use in a continuous deployment environment.'
  s.authors = ["Michael Bruce"]
  s.email = 'mbruce@manta.com'
  s.files += Dir['lib/**/*.rb']
  s.add_runtime_dependency 'aws-sdk'
  s.add_runtime_dependency 'fpm'
  s.add_runtime_dependency 'sinatra'
  s.executables << 'ploy'
end
