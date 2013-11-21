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

      def initialize(opts = {})
        @metadata_dir = "/etc/ploy/metadata.d"
        opts.each { |k,v| instance_variable_set("@#{k}", v) } # maybe?
      end

      def build_deb
        info = nil
        Dir.mktmpdir do |dir|
          mirror_dist(dir, {:dir => @dist_dir, :prefix => @prefix})
          mirror_dist_dirs(dir)
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

      def mirror_dist_dirs(target_root)
        @dist_dirs.each do |source|
          if !source['dir'] or !source['prefix'] then
            raise "invalid dist_dirs entry: " + ap source
          end
          mirror_dist(target_root, source['dir'], source['prefix'])
        end
      end

      def mirror_dist(dir, source)
        FileUtils.mkpath mirror_dist_target(source['dir'], source['prefix'])
        system("rsync -a #{source['dir']}/* #{mirror_dist_target(dir, prefix)}")
      end

      def mirror_dist_target(topdir, prefix)
        return prefix ? File.join(topdir, prefix) : topdir
      end

      def write_after_install_script(file)
        file.write <<SCRIPT
#!/bin/bash

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
            restart #{service}
          else
            start #{service}
          fi
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
