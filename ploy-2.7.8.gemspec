Gem::Specification.new do |s|
  s.name = 'ploy-2.7.8'
  s.version = '0.0.43'
  s.date = '2025-10-08'
  s.summary = 'Multi-phase deployment tool'
  s.description = 'Multi-phase deployment tool for use in a continuous deployment environment.'
  s.authors = ["Michael Bruce", "Brian J. Schrock", "Dustin Watson"]
  s.email = 'mbruce@manta.com'
  s.files += Dir['lib/**/*.rb']
  s.required_ruby_version = '>= 2.7.8'
  s.add_runtime_dependency 'aws-sdk-v1', '1.64'
  s.add_runtime_dependency 'fpm', '1.15.1'
  s.add_runtime_dependency 'sinatra', '1.4.6'
  s.add_runtime_dependency 'nokogiri', '~> 1.13.0'
  s.executables << 'ploy'
end
