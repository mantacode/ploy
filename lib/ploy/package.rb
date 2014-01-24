require 'ploy/common'
require 'ploy/s3storage'

module Ploy
  class Package
    attr_accessor :deploy_name
    attr_accessor :branch
    attr_accessor :version
    attr_accessor :variant

    # initialize a new package

    def initialize(bucket, deploy, branch, version, variant = nil)
      @bucket = bucket
      @deploy_name = deploy
      @branch = branch
      @version = version
      @variant = variant

      @store = Ploy::S3Storage.new(bucket)
    end
    
    # checks if the installed version is not euqal to the remote version of 
    # the repository

    def check_new_version
      installed = `dpkg-query -W -f '${gitrev}' #{@deploy_name}`.chomp
      remote_v = @store.metadata(location)['git_revision']
      return (installed != remote_v)
    end
    
    # installs this package

    def install
      Tempfile.open(['ploy', '.deb']) do |f|
        @store.get(location, f)
        system("dpkg -i #{f.path}")
      end
    end

    # creates a "blessed" package

    def blessed
      return Ploy::Package.new(@bucket, @deploy_name, @branch, @version, "blessed")
    end

    # bless's the package and stores it into a new location

    def bless
      b = self.blessed
      @store.copy(
        location,
        b.location
      )
      return b
    end

    # grab the location of this package

    def location
      return Ploy::Util.remote_name(@deploy_name, @branch, @version, @variant)
    end

    # grab the current location
    
    def location_current
      return Ploy::Util.remote_name(@deploy_name, @branch, 'current', @variant)
    end
    
    # uploads the package to the specified path
    
    def upload(path)
      @store.put(path, location, {'git_revision' => @version})
    end

    # copys the current package into a new location and makes it the current

    def make_current
      @store.copy(location, location_current)
    end

    # class method to create a package given a bucket and meta data

    def self.from_metadata(bucket, meta)
      out = []
      meta.each do |k,v|
        out.push(self.new(bucket, v['name'], v['branch'], v['sha'], v['variant']))
      end
      return out
    end
  end
end
