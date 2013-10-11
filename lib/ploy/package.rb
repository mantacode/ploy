require 'ploy/common'
require 'ploy/s3storage'

module Ploy
  class Package
    attr_accessor :deploy_name
    attr_accessor :branch
    attr_accessor :version

    def initialize(bucket, deploy, branch, version)
      @deploy_name = deploy
      @branch = branch
      @version = version

      @store = Ploy::S3Storage.new(bucket)
    end

    def check_new_version
      installed = `dpkg-query -W -f '${gitrev}' #{@deploy_name}`.chomp
      remote_v = @store.metadata(location)['git_revision']
      return (installed != remote_v)
    end

    def install
      Tempfile.open(['ploy', '.deb']) do |f|
        @store.get(location, f)
        system("dpkg -i #{f.path}")
      end
    end

    def bless
      @store.copy(
        location,
        Ploy::Util.remote_name(@deploy_name, @branch, @version, true)
      )
    end

    def location
      return Ploy::Util.remote_name(@deploy_name, @branch, @version)
    end
    def location_current
      return Ploy::Util.remote_name(@deploy_name, @branch, 'current')
    end

    def upload(path)
      @store.put(path, location, {'git_revision' => @version})
    end

    def make_current
      @store.copy(location, location_current)
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
