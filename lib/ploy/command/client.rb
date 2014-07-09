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
            ips = installable_packages(o[:target_packages], ps.packages)
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
    $ ploy client -b bucket -n this/that/set.yml -d foo -d bar
    $ ploy client -u http://example.com/set.yml -d foo -d bar

  All of those examples will try to install the same packages, but use
  different sources for configuration. The first uses a file, the second
  uses S3, and the third uses a web service.

Summary:

  The client command is like an "install" command that uses external
  configuration instead of command-line options. It can use a file,
  or talk to S3 or a web service.

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
          conf = yr.from_s3(o[:bucket], o[:s3_name])
        elsif o[:http_url] then
          conf = yr.from_http(o[:http_url])
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
          opts.on("-n", "--s3-name S3_NAME", "use the given resource name") do |name|
            o[:s3_name] = name
          end
          opts.on("-u", "--http-url HTTP_URL", "read config from an http URL") do |url|
            o[:http_url] = url
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
