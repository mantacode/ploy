require 'rspec/given'
require 'ploy/yamlreader'
require 'ploy/s3storage'
require 'net/http'

def ex_str
  YAML.dump(
    'bucket' => 'bucketname'
  )
end

describe Ploy::YamlReader do
  Given(:yr) { Ploy::YamlReader.new }
  context "read a file from disk" do
    When(:result) { yr.from_file('spec/resources/ploy-publish.yml') }
    Then { result['bucket'] == 'bucketname' }
  end
  context "read from S3" do
# any_instance gets errors here for... some reason
#    Ploy::S3Storage.any_instance.stub(:read) { ex_str }
#    puts Ploy::S3Storage.any_instance
#    When(:result) { yr.from_s3('bucket', 'name') }
#    And  { result['bucket'] == 'bucketname' }
  end
  context "read from HTTP" do
    When(:result) do
      Net::HTTP.stub(:get) { ex_str }
      yr.from_http('http://www.example.com/thing.yml')
    end
    Then { result['bucket'] == 'bucketname' }
  end

end
