module Ploy
  class PackageSet
    attr_accessor :packages

    # initializes an instance given the configuration
    # the packages are stored into a list

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
          v['variant'] || conf['variant'] || nil
        )
      end
      @locked = conf['locked']
    end

    # is this PackageSet locked?
    
    def locked?
      return @locked ? true : false
    end

  end
end
