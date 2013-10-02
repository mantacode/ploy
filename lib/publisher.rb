require 'yaml'

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

    def publish()
      self.prep()
    end

    def prep()
      if (@conf['prep_cmd']) then
        system(@conf['prep_cmd'])
      end
    end

    def package()
      opts = [
        { "-n" => @conf['deploy_name'] },
        { "-s" => "dir" },
        { "-t" => "deb" },
        @conf['dist_dir']
      ]

      opts_string = stringify_optlist(opts)
      cmd = "fpm #{opts_string}"
      info = eval(`#{cmd}`) # yes, really

      return info[:path]
    end

    def send()

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

  end

end
