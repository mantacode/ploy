Gem::Specification.new do |s|
  s.name = 'ploy'
  s.version = '0.0.42'
  s.date = '2021-05-17'
  s.summary = 'Multi-phase deployment tool'
  s.description = 'Multi-phase deployment tool for use in a continuous deployment environment.'
  s.authors = ["Michael Bruce", "Brian J. Schrock", "Dustin Watson"]
  s.email = 'mbruce@manta.com'
  s.files += Dir['lib/**/*.rb']
  s.add_runtime_dependency 'aws-sdk-v1', '1.64'
  s.add_runtime_dependency 'fpm', '1.12.0'
  s.add_runtime_dependency 'sinatra', '2.2.3'
  s.executables << 'ploy'
end
