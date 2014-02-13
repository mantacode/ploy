require 'ploy/localpackage/config'

module Ploy
  class Publisher

    def initialize(conf_source)
      @config = Ploy::LocalPackage::Config.new conf_source
    end

    def publish
      pkgpath = @config.builder.build_deb
      remote_package = @config.remote_package
      remote_package.upload(pkgpath)
      remote_package.make_current
      return remote_package
    end

  end

end
