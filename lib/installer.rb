require 'tempfile'
require 'common'

module Ploy
  class Installer
    def Installer.install(bucket, deploy, branch, version)
      loc = Ploy::Util.remote_name(deploy, branch, version)
      Tempfile.open(['ploy', '.deb']) do |f|
        AWS::S3.new.buckets[bucket].objects[loc].write do |chunk|
          f.write(chunk)
        end
        system("dpkg -i #{f.path}")
      end
    end
  end
end
