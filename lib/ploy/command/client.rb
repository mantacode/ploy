require 'ploy/command/base'
require 'ploy/yamlreader'
require 'ploy/packageset'
require 'optparse'

module Ploy
  module Command
    class Client < Base
      def run(argv)
        o = {
          :target_packages => []
        }
        optparser(o).parse!(argv)
        conf = conf_from_opts(o)
        
        if conf then
          ps = Ploy::PackageSet.new(conf)
          if ps.locked?
            puts "locked. taking no action."
          else
            puts "tp: #{o[:target_packages]}"
            puts "ap: #{ps.packages}"
            ips = installable_packages(o[:target_packages], ps.packages)
            puts "installing #{ips}"
            ips.each do |package|
              if package.check_new_version then
                package.install
                puts "installed #{package.deploy_name}"
              else
                puts "no new #{package.deploy_name} available"
              end
            end
          end
        else
          puts "error reading conf"
          help()
        end
      end

      def help
        return <<helptext
usage: ploy client OPTS

#{optparser}

Examples:

    $ ploy client -f set.yml -d foo -d bar
    $ ploy client -b bucket -s teststack -d foo -d bar
    $ ploy client -h host -d foo -d bar
    $ ploy client -h host -s teststack -d foo -d bar

  All of those examples will try to install the same packages, but use
  different sources for configuration. The first uses a file, the second
  uses S3, and the final two use a web service.

  The "stack" option is just a name used to group things together. It
  can map directly to an AWS CloudFormation stack name, but doesn't
  have to.

Summary:

  The client command is like an "install" command that uses external
  configuration instead of command-line options. It can use a file,
  or talk to S3 or a web service.

  S3 should be organized like:

    /hub/
      $stackname/
        clientconfig.yml

  The webservice should respond to a call like:

    http://$host:9875/clientconfig/$stack

helptext
      end

      def installable_packages(target_packages, packages)
        tph = {}
        target_packages.each { |tp| tph[tp] = true }
        packages.find_all { |p| tph[p.deploy_name] }
      end

      private
      def conf_from_opts(o)
        yr = Ploy::YamlReader.new
        conf = nil
        if o[:bucket] and o[:stack] then
          conf = yr.from_s3(o[:bucket], "hub/#{o[:stack]}/clientconfig.yml")
        elsif o[:hub_host] then
          stack = o[:stack] || ""
          conf = yr.from_http("http://#{o[:hub_host]}:9875/clientconfig/#{stack}")
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
          opts.on("-s", "--stack STACK_NAME", "use the given stack name") do |stack|
            o[:stack] = stack
          end
          opts.on("-H", "--hub HUB_HOST", "read config from a deployment hub") do |host|
            o[:hub_host] = host
          end
          opts.on("-f", "--file PATH", "read config from file") do |path|
            o[:path] = path
          end
          opts.on("-d", "--deploy DEPLOY_NAME", "a deploy/remote package to install, subject to hub config") do |name|
            o[:target_packages].push(name)
          end
        end
        return options
      end

    end
  end
end
