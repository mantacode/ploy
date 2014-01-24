require 'net/http'

module Ploy
  class YamlReader

    # read from file path

    def from_file(path)
      YAML.load(File.read(path))
    end

    # read from s3 given the bucket and the object name

    def from_s3(bucket, name)
      YAML.load(Ploy::S3Storage.new(bucket).read(name))
    end
    
    # read from an HTTP url 

    def from_http(url)
      txt = Net::HTTP.get(URI(url))
      YAML.load(txt)
    end
  end
end
