require 'ploy/command/base'
require 'ploy/package'
require 'json'

module Ploy
  module Command
    class List < Base
      def run(argv)
        o = {:branch => 'master'}
        optparser(o).parse!(argv)
        pkgs = []
        if (o[:datapath]) then
          pkgs = Ploy::Package.from_metadata(o[:bucket], JSON.parse(File.read(o[:datapath])))
        else
          pkgs.push Ploy::Package.new(o[:bucket], o[:deploy], o[:branch], o[:version])
        end

        store = Ploy::S3Storage.new(o[:bucket])
        store.list.each do |name|
          current = Ploy::Package.new(bucket, name, branch, 'current').remote_version
          blessed_current = Ploy::Package.new(bucket, name, branch, 'current', 'blessed').remote_version

          puts "#{name} #{branch} #{current} #{blessed_current}"
        end
      end

      def help
        return <<helptext
usage: ploy -b BUCKET [-d DEPLOYMENT -B BRANCH]

#{optparser}

Examples:
  $ ploy list -b deploybucket

Summary

  The list command lists available published packages, their current sha, and their current blessed sha.
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
        end
        return options
      end

    end
  end
end
