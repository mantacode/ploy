require 'aws-sdk'

module Ploy
  class S3Storage
    def initialize(bucket)
      @bucketname = bucket
    end

    def put(path, name, meta = {})
      Aws::S3::Resource.new.buckets[@bucketname].objects[name].write(
        Pathname.new(path),
        { :metadata => meta }
      )
    end

    def copy(from, to)
      Aws::S3::Resource.new.buckets[@bucketname].objects[from].copy_to(to)
    end

    def read(from)
      Aws::S3::Resource.new.buckets[@bucketname].objects[from].read
    end

    def get(from, fileio)
      Aws::S3::Resource.new.buckets[@bucketname].objects[from].read do |chunk|
        fileio.write(chunk)
      end
      fileio.flush
    end

    def metadata(loc)
      o = Aws::S3::Resource.new.buckets[@bucketname].objects[loc]
      if (o.exists?) then
        return o.metadata
      else
        return {}
      end
    end

    def list
      tree = Aws::S3::Resource.new.buckets[@bucketname].as_tree
      dirs = tree.children.select(&:branch?).collect(&:prefix)
      package_names = []
      dirs.each do |dir|
        dir.chop!
        if dir != 'hub' && dir != 'blessed' && dir != 'staging'
          package_names.push(dir)
        end
      end
      return package_names
    end
  end
end
