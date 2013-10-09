require 'yaml'
require 'tmpdir'
require 'fileutils'
require 'aws-sdk'
require 'ploy/common'
require 'ploy/s3storage'

module Ploy
  class Publisher
    def initialize(conf_source)
      @conf = conf_source
      if (/^---/ =~ conf_source) then
        @conf = YAML::load(conf_source)
      else
        @conf = YAML::load_file(conf_source)
      end
      @storage = Ploy::S3Storage.new(@conf['bucket'])
    end

    def publish
      self.prep
      pkgpath = self.package
      self.send(pkgpath)
      self.make_current # some embedded assumptions here
    end

    def prep
      if (@conf['prep_cmd']) then
        system(@conf['prep_cmd'])
      end
    end

    def remote_target_name
      return Ploy::Util.remote_name(@conf['deploy_name'], git_branch, git_revision)
    end

    def remote_current_copy_name
      return Ploy::Util.remote_name(@conf['deploy_name'], git_branch, 'current')
    end

    def package
      Dir.mktmpdir do |dir|
        mirror_dist(dir)

        opts = [
          { "-n" => @conf['deploy_name'] },
          { "-s" => "dir" },
          { "-t" => "deb" },
          { "-a" => "all" },
          { "-C" => dir },
          { "--deb-field" => "'gitrev: #{git_revision}'" },
          "-f",
          { "-v" => git_timestamp + '.' + git_branch },
          "."
        ]

        if (@conf['upstart_files']) then
          @conf['upstart_files'].each do | upstart |
            opts.unshift({ "--deb-upstart" => upstart })
          end
        end

        write_metadata(dir)

        opts_string = stringify_optlist(opts)
        cmd = "fpm #{opts_string}"
        info = eval(`#{cmd}`) # yes, really

        return info[:path]
      end
    end

    def send(path)
      @storage.put(path, remote_target_name, {'git_revision' => git_revision})
    end

    def make_current
      @storage.copy(remote_target_name, remote_current_copy_name)
    end

    private

    def stringify_optlist(opts)
      opts_flat = []

      opts.each do | e |
        if (e.is_a? Hash) then
          e.each { | k, v| opts_flat.push([k,v].join(' ')) }
        else
          opts_flat.push(e)
        end
      end

      return opts_flat.join(' ')
    end

    def mirror_dist(dir)
      dist_target = dir
      if (@conf['prefix']) then
        dist_target = File.join(dist_target, @conf['prefix'])
      end
      FileUtils.mkpath dist_target
      system("rsync -aC #{@conf['dist_dir']}/* #{dist_target}")
    end

    def write_metadata(dir)
      base = File.join(dir, "/etc/ploy/metadata.d")
      FileUtils.mkpath(base)
      path = File.join(base, "#{@conf['deploy_name']}.yml")
      info = {
        "name"      => @conf['deploy_name'],
        "sha"       => git_revision,
        "timestamp" => git_timestamp,
        "branch"    => git_branch
      }
      File.open(path, 'w') do | out |
        YAML.dump(info, out)
      end
    end

    def git_branch
      return ENV['TRAVIS_BRANCH'] || `git symbolic-ref --short -q HEAD`.chomp
    end

    def git_revision
      return `git rev-parse HEAD`.chomp
    end

    def git_timestamp
      return `git log -1 --pretty=format:"%ct"`
    end

  end

end
