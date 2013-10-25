require 'yaml'
require 'ploy/localpackage/optlist'

module Ploy
  module LocalPackage
    class DebBuilder
      attr_accessor :name
      attr_accessor :sha
      attr_accessor :branch
      attr_accessor :timestamp
      attr_accessor :upstart_files
      attr_accessor :dist_dir
      attr_accessor :prefix

      def initialize(opts = {})
        @metadata_dir = "/etc/ploy/metadata.d"
        opts.each { |k,v| instance_variable_set("@#{k}", v) } # maybe?
      end

      def build_deb
        info = nil
        Dir.mktmpdir do |dir|
          mirror_dist(dir)
          write_metadata(dir)
          info = eval(`fpm #{fpm_optlist(dir).as_string} .`)
        end
        return info[:path]
      end

      def fpm_optlist(dir)
        optlist = Ploy::LocalPackage::DebBuilderOptlist.new [
          { "-n" => @name },
          { "-s" => "dir" },
          { "-t" => "deb" },
          { "-a" => "all" },
          { "-C" => dir },
          { "--deb-field" => "'gitrev: #{@sha}'" },
          "-f",
          { "-v" => safeversion(@timestamp + '.' + @branch) },
        ]

        if @upstart_files then
          @upstart_files.each do | upstart |
            optlist.add("--deb-upstart", upstart)
          end
        end

        return optlist
      end

      def safeversion(txt)
        return txt.gsub(/[^A-Za-z0-9\.\+]/, '')
      end

      def mirror_dist(dir)
        FileUtils.mkpath mirror_dist_target(dir)
        system("rsync -aC #{@dist_dir}/* #{mirror_dist_target(dir)}")
      end

      def mirror_dist_target(topdir)
        return @prefix ? File.join(topdir, @prefix) : topdir
      end

      def write_metadata(dir)
        base = File.join(dir, @metadata_dir)
        FileUtils.mkpath(base)
        path = File.join(base, "#{@name}.yml")
        info = {
          "name"      => @name,
          "sha"       => @sha,
          "timestamp" => @timestamp,
          "branch"    => @branch, 
        }
        File.open(path, 'w') do | out |
          YAML.dump(info, out)
        end

      end
    end
  end
end
