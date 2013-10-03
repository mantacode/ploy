require 'yaml'
require 'tmpdir'
require 'fileutils'
require 'aws-sdk'

module Ploy
  class Publisher
    def initialize(conf_source)
          @conf = conf_source
          if (/^---/ =~ conf_source) then
            @conf = YAML::load(conf_source)
          else
            @conf = YAML::load_file(conf_source)
          end
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
      return remote_name(@conf['deploy_name'], git_branch, git_revision)
    end

    def remote_current_copy_name
      return remote_name(@conf['deploy_name'], git_branch, 'current')
    end

    def package
      Dir.mktmpdir do |dir|
        mirror_dist(dir)

        opts = [
          { "-n" => @conf['deploy_name'] },
          { "-s" => "dir" },
          { "-t" => "deb" },
          { "-C" => dir },
          "-f",
          { "-v" => git_branch + '.' + git_timestamp },
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
      s3 = AWS::S3.new
      pn = Pathname.new(path)
      s3.buckets[@conf['bucket']].objects[remote_target_name].write(:file => pn)
    end

    def make_current
      s3 = AWS::S3.new
      s3.buckets[@conf['bucket']].objects[remote_target_name].copy_to(remote_current_copy_name)
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
        :name      => @conf['deploy_name'],
        :sha       => git_revision,
        :timestamp => git_timestamp,
        :branch    => git_branch
      }
      File.open(path, 'w') do | out |
        YAML.dump(info, out)
      end
    end

    def remote_name(deploy,branch,rev)
      return [
        deploy,
        branch,
        "#{deploy}_#{rev}.deb"
      ].join('/')
    end

    def git_branch
      return `git symbolic-ref --short -q HEAD`.chomp
    end

    def git_revision
      return `git rev-parse HEAD`.chomp
    end

    def git_timestamp
      return `git log -1 --pretty=format:"%ct"`
    end

  end

end
