module Ploy
  class PackageSet
    attr_accessor :packages

    def initialize(conf)
      self.packages = []
      conf['packages'].each do |k,v|
        if (not v)
          v = {}
        end
        self.packages.push Ploy::Package.new(
          conf['bucket'] || v['bucket'],
          k,
          v['branch'] || conf['branch'],
          v['version'] || conf['version'],
          v['variant'] || conf['variant'] || nil,
          v['updatevia'] || conf['updatevia'] || nil
        )
      end
      @locked = conf['locked']
    end

    def locked?
      return @locked ? true : false
    end

  end
end
