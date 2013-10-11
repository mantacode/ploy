require 'yaml'
require 'tmpdir'
require 'fileutils'
require 'aws-sdk'
require 'ploy/s3storage'
require 'ploy/packager'

module Ploy
  class Publisher
    def initialize(conf_source)
      @conf = conf_source
      if (/^---/ =~ conf_source) then
        @conf = YAML::load(conf_source)
      else
        @conf = YAML::load_file(conf_source)
      end
      @local_packager = Ploy::LocalPackager.new(conf_source)
    end

    def publish
      pkgpath = @local_packager.build_deb
      remote_package = @local_packager.remote_package
      remote_package.upload(pkgpath)
      remote_package.make_current
      return remote_package
    end

  end

end
