require 'tempfile'
require 'common'

module Ploy
  class Installer
    def Installer.install(bucket, deploy, branch, version)
      loc = Ploy::Util.remote_name(deploy, branch, version)
      Tempfile.open(['ploy', '.deb']) do |f|
        AWS::S3.new.buckets[bucket].objects[loc].read do |chunk|
          f.write(chunk)
        end
        f.flush # this is kind of important, it turns out
        system("dpkg -i #{f.path}")
      end
    end
  end
end
