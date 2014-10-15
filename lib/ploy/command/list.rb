require 'ploy/command/base'
require 'ploy/package'
require 'json'
require 'yaml'

module Ploy
  module Command
    class List < Base

      def run(argv)
        o = { branch: 'master', all: false, json: false, deploy: nil, variant: 'blessed' }
        optparser(o).parse!(argv)

        bucket = o[:bucket]
        branch = o[:branch]

        packages = o[:deploy].nil? ? Ploy::S3Storage.new(bucket).list : [o[:deploy]]

        packages.each_with_object([]) do |name, json_array|
          current = Ploy::Package.new(bucket, name, branch, 'current').remote_version
          blessed_current = Ploy::Package.new(bucket, name, branch, 'current', o[:variant]).remote_version

          if o[:all] || current != blessed_current
            if o[:json]
              h = { name => {
                  'name'        => name,
                  'sha'         => current,
                  'branch'      => branch,
                  'blessed_sha' => blessed_current
                } }
              puts h.to_json
              json_array << h
            else
              puts "#{name} #{branch} #{current} #{blessed_current}"
            end
          end
        end.to_json
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
          opts.on("--variant VARIANT", "bless with a different variant. default is (blessed)") do |variant|
            o[:variant] = variant
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
