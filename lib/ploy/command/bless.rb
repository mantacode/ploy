require 'ploy/command/base'
require 'ploy/package'
require 'json'

module Ploy
  module Command
    class Bless < Base
      def run(argv)
        o = {}
        optparser(o).parse!(argv)
        pkgs = []
        if (o[:datapath]) then
          pkgs = Ploy::Package.from_metadata(o[:bucket], JSON.parse(File.read(o[:datapath])))
        else
          pkgs.push Ploy::Package.new(o[:bucket], o[:deploy], o[:branch], o[:version])
        end

        pkgs.each do |pkg|
          blessed = pkg.bless
          blessed.make_current
          puts "blessed #{o[:deploy]}/#{o[:branch]} at #{o[:version]}"
        end
      end

      def help
        return <<helptext
usage: ploy -b BUCKET [-d DEPLOYMENT -B BRANCH -v VERSION | -f DATAFILE]

#{optparser}

Examples:
  $ ploy bless -b deploybucket -d someproject -B master -v 6d4a094dcaad6e421f85b24c7c75153db72ab00c
  $ ploy bless -b deploybucket -f /tmp/version_info.json

Summary

  The bless command takes action to verify that specific package is "blessed" to go to production.
  It should only be marked as such after a successful run through unit, integration and smoke
  tests.

helptext
      end

      private
      def optparser(o = {})
        options = OptionParser.new do |opts|
          opts.banner = ''
          opts.on("-b", "--bucket BUCKET", "use the given S3 bucket") do |bucket|
            o[:bucket] = bucket
          end
          opts.on("-d", "--deployment DEPLOYMENT", "bless the given deployment (project)") do |dep|
            o[:deploy] = dep
          end
          opts.on("-B", "--branch BRANCH", "use the deployment from the given branch") do |branch|
            o[:branch] = branch
          end
          opts.on("-v", "--version VERSION", "use the given version") do |v|
            o[:version] = v
          end
          opts.on("-f", "--data-file PATH", "load a set of dep/branch/version data from a", "version file compatible with ploy oracle output") do |path|
            o[:datapath] = path
          end
        end
        return options
      end

    end
  end
end
