require 'net/http'
require 'json'
require 'aws-sdk-ec2'

module Ploy
  class MetaOracle
    def initialize(stack)
      @stack = stack
      @ec2 = Aws::EC2::Resource.new
    end

    def query
      r = {}
      puts "query"
      # Find instances with the stack tag
      @ec2.instances(filters: [{name: 'tag:Name', values: [@stack]}]).each do |i|
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
