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
    'lib/common.rb'
  ]
  s.executables << 'ploy'
end
