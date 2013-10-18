module Ploy
  class PackageSet
    attr_accessor :packages

    def initialize(conf)
      self.packages = []
      conf['packages'].each do |k,v|
        self.packages.push Ploy::Package.new(v['bucket'], v['name'], v['branch'], v['version'])
      end
      @locked = conf['locked']
    end

    def locked?
      return @locked ? true : false
    end

  end
end
