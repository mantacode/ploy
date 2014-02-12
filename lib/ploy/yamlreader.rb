require 'net/http'

module Ploy
  class YamlReader
    def from_file(path)
      YAML.load(File.read(path))
    end

    def from_s3(bucket, name)
      YAML.load(Ploy::S3Storage.new(bucket).read(name))
    end
    
    def from_http(url)
      txt = Net::HTTP.get(URI(url))
      YAML.load(txt)
    end
  end
end
