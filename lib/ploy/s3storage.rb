require 'aws-sdk'

module Ploy
  class S3Storage

    # initialize an instance using this bucket

    def initialize(bucket)
      @bucketname = bucket
    end

    # write to the path given the name and default meta data

    def put(path, name, meta = {})
      AWS::S3.new.buckets[@bucketname].objects[name].write(
        Pathname.new(path),
        { :metadata => meta },
      )
    end

    # copies object from and to

    def copy(from, to)
      AWS::S3.new.buckets[@bucketname].objects[from].copy_to(to)
    end

    # reads and object from

    def read(from)
      AWS::S3.new.buckets[@bucketname].objects[from].read
    end

    # gets an object and writes it to the an output stream 

    def get(from, fileio)
      AWS::S3.new.buckets[@bucketname].objects[from].read do |chunk|
        fileio.write(chunk)
      end
      fileio.flush
    end

    # gets the meta data given the location

    def metadata(loc)
      o = AWS::S3.new.buckets[@bucketname].objects[loc] 
      if (o.exists?) then
        return o.metadata
      else
        return {}
      end
    end
  end
end
