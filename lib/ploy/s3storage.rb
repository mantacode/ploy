require 'aws-sdk-s3'

module Ploy
  class S3Storage
    def initialize(bucket)
      @bucketname = bucket
      @s3 = Aws::S3::Resource.new
      @bucket = @s3.bucket(@bucketname)
    end

    def put(path, name, meta = {})
      obj = @bucket.object(name)
      File.open(path.to_s, 'rb') do |file|
        obj.put(body: file, metadata: meta)
      end
    end

    def copy(from, to)
      @bucket.object(to).copy_from(
        copy_source: "#{@bucketname}/#{from}"
      )
    end

    def read(from)
      @bucket.object(from).get.body.read
    end

    def get(from, fileio)
      @bucket.object(from).get do |chunk|
        fileio.write(chunk)
      end
      fileio.flush
    end

    def metadata(loc)
      obj = @bucket.object(loc)
      begin
        obj.head.metadata
      rescue Aws::S3::Errors::NotFound
        {}
      end
    end

    def list
      package_names = []
      # List objects with delimiter to get "directories"
      @bucket.objects(delimiter: '/').each do |obj_summary|
        prefix = obj_summary.key
        prefix.chop! if prefix.end_with?('/')
        unless ['hub', 'blessed', 'staging'].include?(prefix)
          package_names.push(prefix)
        end
      end
      package_names
    end
  end
end
