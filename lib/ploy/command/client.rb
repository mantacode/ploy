require 'ploy/command/base'
require 'ploy/yamlreader'
require 'ploy/packageset'
require 'optparse'

module Ploy
  module Command
    class Client < Base
      def run(argv)
        o = {
        }
        optparser(o).parse!(argv)
        conf = conf_from_opts(o)
        
        if conf then
          ps = Ploy::PackageSet.new(conf)
          if ps.locked?
            puts "locked. taking no action."
          else
            ps.packages.each do |package|
              package.install
            end
          end
        else
          puts "error reading conf"
          help()
        end
      end

      def help
      end

      private
      def conf_from_opts(o)
        yr = Ploy::YamlReader.new
        conf = nil
        if o[:bucket] and o[:stack] then
          conf = yr.from_s3(o[:bucket], "hub/#{o[:stack]}/conf.yml")
        elsif o[:hub_host] then
          stack = o[:stack] || ""
          conf = yr.from_http("http://#{o[:hub_host]}:9875/conf/#{stack}")
        elsif o[:path] then
          conf = yr.from_file(o[:path])
        end
        return conf
      end

      def optparser(o = {})
        options = OptionParser.new do |opts|
          opts.banner = ''
          opts.on("-b", "--bucket BUCKET", "use the given S3 bucket") do |bucket|
            o[:bucket] = bucket
          end
          opts.on("-b", "--stack STACK_NAME", "use the given stack name") do |stack|
            o[:stack] = stack
          end
          opts.on("-H", "--hub HUB_HOST", "install the given deployment (project)") do |host|
            o[:hub_host] = host
          end
          opts.on("-f", "--file PATH", "use the deployment from the given branch") do |path|
            o[:path] = path
          end
        end
        return options
      end

    end
  end
end
