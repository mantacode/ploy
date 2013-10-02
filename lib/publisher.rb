require 'yaml'

module Ploy
  class Publisher

    class << self

      def publish(conf_source)
        conf = process_conf(conf_source)

        system(conf['prep_cmd'])
      end

      private
        def process_conf(conf_source)
          conf = conf_source
          if (/^---/ =~ conf_source) then
            conf = YAML::load(conf_source)
          else
            conf = YAML::load_file(conf_source)
          end
          return conf
        end
    end
  end
end
