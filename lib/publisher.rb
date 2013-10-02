require 'yaml'
require 'tmpdir'

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
      self.prep()
    end

    def prep
      if (@conf['prep_cmd']) then
        system(@conf['prep_cmd'])
      end
    end

    def package
      Dir.mktmpdir do |dir|
        mirror_dist(dir)

        opts = [
          { "-n" => @conf['deploy_name'] },
          { "-s" => "dir" },
          { "-t" => "deb" },
          { "-C" => dir },
          { "-v" => git_branch + '.' + git_timestamp },
          "."
        ]

        if (@conf['upstart_files']) then
          @conf['upstart_files'].each do | upstart |
            opts.unshift({ "--deb-upstart" => upstart })
          end
        end

        pp opts

        opts_string = stringify_optlist(opts)
        cmd = "fpm #{opts_string}"
        pp cmd
        info = eval(`#{cmd}`) # yes, really

        return info[:path]
      end
    end


    def send

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
      system("find #{dir}")
      if (@conf['prefix']) then
        dist_target = File.join(dist_target, @conf['prefix'])
      end
      system("mkdir -p #{dist_target}")
      system("rsync -aC #{@conf['dist_dir']}/* #{dist_target}")
    end

    def write_metadata(dir)
      path = File.join(dir, ".ploy-metadata.yml")
      info = {
        name      => @conf['deploy_name'],
        sha       => git_revision,
        timestamp => git_timestamp,
        branch    => git_branch
      }
      File.open(path, 'w') do | out |
        YAML.dump(info, out)
      end
    end

    def git_branch
      return `git symbolic-ref --short -q HEAD`.chomp
    end

    def git_timestamp
      return `git log -1 --pretty=format:"%ct"`
    end

  end

end
