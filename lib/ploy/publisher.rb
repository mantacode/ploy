require 'ploy/localpackage/config'

module Ploy
  class Publisher
    def initialize(conf_source)
      @configs = Ploy::LocalPackage::Config.load(conf_source)
    end

    def publish
      remotes = []
      @configs.each do |config|
        pkgpath = config.builder.build_deb
        remote_package = config.remote_package
        remote_package.upload(pkgpath)
        remote_package.make_current
        remotes.push(remote_package)
      end
      return remotes
    end

  end

end
