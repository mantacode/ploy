require 'ploy/localpackage/config'

module Ploy
  class Publisher

    # initializes a new instance given the conf_source

    def initialize(conf_source)
      @config = Ploy::LocalPackage::Config.new conf_source
    end

    # publishes the local package to the remote destination
    # and returns the remote package

    def publish
      pkgpath = @config.builder.build_deb
      remote_package = @config.remote_package
      remote_package.upload(pkgpath)
      remote_package.make_current
      return remote_package
    end

  end

end
