require 'ploy/command/base'
require 'ploy/package'

module Ploy
  module Command
    class Bless < Base
      def run(argv)
        o = {}
        optparser(o).parse!(argv)
        pkg = Ploy::Package.new(o[:bucket], o[:deploy], o[:branch], o[:version])
        pkg.bless
        puts "blessed #{o[:deploy]}/#{o[:branch]} at #{o[:version]}"
      end

      def help
        return <<helptext
usage: ploy -b BUCKET -d DEPLOYMENT -B BRANCH -v VERSION

#{optparser}

Examples:
  $ ploy bless -b deploybucket -d someproject -B master -v 6d4a094dcaad6e421f85b24c7c75153db72ab00c

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
        end
        return options
      end

    end
  end
end
