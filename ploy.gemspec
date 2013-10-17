Gem::Specification.new do |s|
  s.name = 'ploy'
  s.version = '0.0.4'
  s.date = '2013-03-10'
  s.summary = 'deployment'
  s.description = 'deployment'
  s.authors = ["Michael Bruce"]
  s.email = 'mbruce@manta.com'
  s.files += Dir['lib/**/*.rb']
  s.add_runtime_dependency 'aws-sdk'
  s.add_runtime_dependency 'fpm'
  s.add_runtime_dependency 'sinatra'
  s.executables << 'ploy'
end
