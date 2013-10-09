require 'tempfile'
require 'ploy/common'
require 'ploy/s3storage'

module Ploy
  class Installer
    def initialize(bucket, deploy, branch, version)
      @bucketname = bucket
      @deploy = deploy
      @branch = branch
      @version = version
    end

    def install
      Tempfile.open(['ploy', '.deb']) do |f|
        Ploy::S3Storage.new(@bucketname).get(loc, f)
        system("dpkg -i #{f.path}")
      end
    end

    def check_new_version
      installed = `dpkg-query -W -f '${gitrev}' #{@deploy}`.chomp
      remote_v = Ploy::S3Storage.new(@bucketname).metadata(loc)['git_revision']
      puts "#{installed} <> #{remote_v}"
      return (installed != remote_v)
    end

    private 
    def loc
      return Ploy::Util.remote_name(@deploy, @branch, @version)
    end

  end
end
