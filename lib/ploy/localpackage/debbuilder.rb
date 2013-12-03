require 'yaml'
require 'ploy/localpackage/optlist'
require 'tempfile'

module Ploy
  module LocalPackage
    class DebBuilder
      attr_accessor :name
      attr_accessor :sha
      attr_accessor :branch
      attr_accessor :timestamp
      attr_accessor :upstart_files
      attr_accessor :dist_dirs
      attr_accessor :dist_dir
      attr_accessor :prefix
      attr_accessor :postinst

      def initialize(opts = {})
        @metadata_dir = "/etc/ploy/metadata.d"
        opts.each { |k,v| instance_variable_set("@#{k}", v) } # maybe?
      end

      def build_deb
        info = nil
        Dir.mktmpdir do |dir|
          dist_dirs = Array.new(@dist_dirs || [])
          if @dist_dir
            dist_dirs.unshift({'dir' => @dist_dir, 'prefix' => @prefix})
          end
          mirror_dists(dir, dist_dirs)
          #mirror_dist(dir, @prefix, @dist_dir)
          write_metadata(dir)
          Tempfile.open(['postinst', 'sh']) do |file|
            write_after_install_script(file)
            ol = fpm_optlist(dir)
            ol.add("--after-install", file.path)
            puts "debug: fpm #{ol.as_string} ."
            info = eval(`fpm #{ol.as_string} .`)
          end
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

      def mirror_dists(topdir, dist_dirs)
        dist_dirs.each do |source|
          mirror_dist(topdir, source['prefix'], source['dir'])
        end
      end

      def mirror_dist(topdir, prefix, source_dir)
        FileUtils.mkpath mirror_dist_target(topdir, prefix)
        system("rsync -a #{source_dir}/* #{mirror_dist_target(topdir, prefix)}")
      end

      def mirror_dist_target(topdir, prefix)
        return prefix ? File.join(topdir, prefix) : topdir
      end

      def write_after_install_script(file)
        file.write <<SCRIPT
#!/bin/bash

#{postinst}

# this is awful
check_upstart_service(){
    status $1 | grep -q "^$1 start" > /dev/null
    return $?
}
SCRIPT
        @upstart_files.each do | upstart |
          service = File.basename(upstart)
          file.write <<SCRIPT
          if check_upstart_service #{service}; then
            stop #{service}
          fi
          start #{service}
SCRIPT
        end
        file.flush
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
