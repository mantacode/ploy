require 'ploy/common'
require 'ploy/s3storage'

module Ploy
  class Package
    def initialize(bucket, deploy, branch, version)
      @bucketname = bucket
      @deploy = deploy
      @branch = branch
      @version = version
    end

    def check_new_version
      installed = `dpkg-query -W -f '${gitrev}' #{@deploy}`.chomp
      remote_v = Ploy::S3Storage.new(@bucketname).metadata(location)['git_revision']
      return (installed != remote_v)
    end

    def install
      Tempfile.open(['ploy', '.deb']) do |f|
        Ploy::S3Storage.new(@bucketname).get(location, f)
        system("dpkg -i #{f.path}")
      end
    end

    def bless
      Ploy::S3Storage.new(@bucketname).copy(
        location,
        Ploy::Util.remote_name(@deploy, @branch, @version, true)
      )
    end

    def location
      return Ploy::Util.remote_name(@deploy, @branch, @version)
    end

    def self.from_metadata(bucket, meta)
      out = []
      meta.each do |k,v|
        out.push(self.new(bucket, v['name'], v['branch'], v['sha']))
      end
      return out
    end
  end
end
