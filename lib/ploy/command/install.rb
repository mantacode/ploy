require 'ploy/command/base'
require 'optparse'
require 'ploy/package'

module Ploy
  module Command
    class Install < Base

      def run(argv, input='')
        o = {
          :version => 'current',
          :branch  => 'master',
          :check   => true,
          :variant => nil
        }
        optparser(o).parse!(argv)
        pkg = Ploy::Package.new(o[:bucket], o[:deploy], o[:branch], o[:version], o[:variant])
        if (!o[:check] || pkg.check_new_version)
          pkg.install()
          puts "installed #{o[:deploy]}"
        else
          puts "no new version available"
        end
        return true
      end

      def help
        return <<helptext
usage: ploy install -b $bucket -d $deployment -B $branch -v $version [-r $variant]

#{optparser}

Examples:
  $ ploy install -b deploybucket -d someproject # default to master branch and current version
  $ ploy install -b deploybucket -d someproject -B master -v current
  $ ploy install -b deploybucket -d someproject -B master -v 6d4a094dcaad6e421f85b24c7c75153db72ab00c

Summary:

  The install command will download and install a package that matches the
  specification given on the command line. If the available version has the
  same git revision as a currently installed version, it will do nothing.

helptext

      end

      private
      def optparser(o = {})
        options = OptionParser.new do |opts|
          opts.banner = ''
          opts.on("-b", "--bucket BUCKET", "use the given S3 bucket") do |bucket|
            o[:bucket] = bucket
          end
          opts.on("-d", "--deployment DEPLOYMENT", "install the given deployment (project)") do |dep|
            o[:deploy] = dep
          end
          opts.on("-B", "--branch BRANCH", "use the deployment from the given branch") do |branch|
            o[:branch] = branch
          end
          opts.on("-v", "--version VERSION", "use the given version") do |v|
            o[:version] = v
          end
          opts.on("-r", "--variant VARIANT", "use the given vaRiant (e.g. 'blessed')") do |v|
            o[:variant] = v
          end
        end
        return options
      end

    end
  end
end
