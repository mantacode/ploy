require 'tempfile'
require 'ploy/common'
require 'ploy/s3storage'

module Ploy
  class Installer
    def Installer.install(bucket, deploy, branch, version)
      loc = Ploy::Util.remote_name(deploy, branch, version)
      Tempfile.open(['ploy', '.deb']) do |f|
        Ploy::S3Storage.new(bucket).get(loc, f)
        system("dpkg -i #{f.path}")
      end
    end
  end
end
