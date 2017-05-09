Gem::Specification.new do |s|
  s.name = 'ploy'
  s.version = '0.0.36'
  s.date = '2017-01-03'
  s.summary = 'Multi-phase deployment tool'
  s.description = 'Multi-phase deployment tool for use in a continuous deployment environment.'
  s.authors = ["Michael Bruce", "Brian J. Schrock", "Dustin Watson"]
  s.email = 'mbruce@manta.com'
  s.files += Dir['lib/**/*.rb']
  s.add_runtime_dependency 'aws-sdk-v1', '1.64'
  s.add_runtime_dependency 'fpm'
  s.add_runtime_dependency 'sinatra'
  s.executables << 'ploy'
end
