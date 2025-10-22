Gem::Specification.new do |s|
  s.name = 'ploy-3.1.6'
  s.version = '0.0.46'
  s.date = '2025-10-21'
  s.summary = 'Multi-phase deployment tool'
  s.description = 'Multi-phase deployment tool for use in a continuous deployment environment.'
  s.authors = ["Michael Bruce", "Brian J. Schrock", "Dustin Watson"]
  s.email = 'mbruce@manta.com'
  s.files += Dir['lib/**/*.rb']
  s.required_ruby_version = '>= 3.1.0'
  s.add_runtime_dependency 'aws-sdk-s3', '~> 1.140'
  s.add_runtime_dependency 'aws-sdk-ec2', '~> 1.450'
  s.add_runtime_dependency 'fpm', '1.15.1'
  s.add_runtime_dependency 'sinatra', '~> 2.2'
  s.add_runtime_dependency 'nokogiri', '~> 1.15'
  s.add_runtime_dependency 'webrick', '~> 1.8'
  s.executables << 'ploy'
end
