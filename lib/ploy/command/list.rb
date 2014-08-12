require 'ploy/command/base'
require 'ploy/package'
require 'json'

module Ploy
  module Command
    class List < Base
      def run(argv)
        o = {:branch => 'master', :all => false}
        optparser(o).parse!(argv)
        pkgs = []
        if (o[:datapath]) then
          pkgs = Ploy::Package.from_metadata(o[:bucket], JSON.parse(File.read(o[:datapath])))
        else
          pkgs.push Ploy::Package.new(o[:bucket], o[:deploy], o[:branch], o[:version])
        end

        bucket = o[:bucket]
        branch = o[:branch]

        store = Ploy::S3Storage.new(bucket)
        store.list.each do |name|
          current = Ploy::Package.new(bucket, name, branch, 'current').remote_version
          blessed_current = Ploy::Package.new(bucket, name, branch, 'current', 'blessed').remote_version

          if o[:all] || current != blessed_current
            puts "#{name} #{branch} #{current} #{blessed_current}"
          end
        end
      end

      def help
        return <<helptext
usage: ploy -b BUCKET [-d DEPLOYMENT -B BRANCH]

#{optparser}

Examples:
  $ ploy list -b deploybucket

Summary

  The list command lists published packages, their current sha, and
  their current blessed sha. (By default it only lists packages where
  blessed is not current.)
helptext
      end

      private
      def optparser(o)
        options = OptionParser.new do |opts|
          opts.banner = ''
          opts.on("-b", "--bucket BUCKET", "use the given S3 bucket") do |bucket|
            o[:bucket] = bucket
          end
          opts.on("-d", "--deployment DEPLOYMENT", "only return results for the given deployment") do |dep|
            o[:deploy] = dep
          end
          opts.on("-B", "--branch BRANCH", "use the given branch instead of #{o[:branch]}") do |branch|
            o[:branch] = branch
          end

          opts.on("-a", "--all", "include packages where blessed is current") do |asdf|
            o[:all] = true
          end
        end
        return options
      end

    end
  end
end
