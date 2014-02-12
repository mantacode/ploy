require 'net/http'
require 'json'

module Ploy
  class MetaOracle

    def initialize(stack)
      @stack = stack
    end

    # Queries the meta data for the tagged values and returns the results
    # as a hash

    def query
      r = {}
      puts "query"
      AWS::EC2.new.instances.tagged_values(@stack).each do |i|
        puts "asking #{i.private_ip_address}"
        r[i.private_ip_address] = meta(i)
      end
      return r
    end

    def meta(instance)
      JSON.parse(Net::HTTP.get(oracle_uri(instance)))
    end

    def oracle_uri(instance)
        URI("http://#{instance.private_ip_address}:9876/")
    end

  end
end
