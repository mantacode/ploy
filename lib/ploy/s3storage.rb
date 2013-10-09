module Ploy
  class S3Storage
    def initialize(bucket)
      @bucketname = bucket
    end

    def put(path, name, meta = {})
      AWS::S3.new.buckets[@bucketname].objects[name].write(
        { :file => Pathname.new(path) },
        { :metadata => meta }
      )
    end

    def copy(from, to)
      AWS::S3.new.buckets[@bucketname].objects[from].copy_to(to)
    end
    
    def get(from, fileio)
      AWS::S3.new.buckets[@bucketname].objects[from].read do |chunk|
        fileio.write(chunk)
      end
      fileio.flush
    end
  end
end
