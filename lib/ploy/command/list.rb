require 'ploy/command/base'
require 'ploy/package'
require 'json'
require 'yaml'

module Ploy
  module Command
    class List < Base
      def run(argv)
        o = {:branch => 'master', :all => false, :json => false, :deploy => nil}
        optparser(o).parse!(argv)
        #puts o.to_yaml

        bucket = o[:bucket]
        branch = o[:branch]

        packages = []
        if o[:deploy].nil?
          store = Ploy::S3Storage.new(bucket)
          packages = store.list
        else
          packages = [o[:deploy]]
        end

        packages.each do |name|
          current = Ploy::Package.new(bucket, name, branch, 'current').remote_version
          blessed_current = Ploy::Package.new(bucket, name, branch, 'current', 'blessed').remote_version

          if o[:all] || current != blessed_current
            if o[:json]
              h = { name => {
                'name'        => name,
                'sha'         => current,
                'branch'      => branch,
                'blessed_sha' => blessed_current
              } }
              puts h.to_json
            else
              puts "#{name} #{branch} #{current} #{blessed_current}"
            end 
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
          opts.on("-j", "--json", "output json suitable for bless") do |asdf|
            o[:json] = true
          end
        end
        return options
      end

    end
  end
end
