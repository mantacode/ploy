require 'ploy/localpackage/debbuilder'

module Ploy
  module LocalPackage
    class Config
      def initialize(conf_source = '.ploy-publisher.yml')
        @conf = conf_source
        if (/^---/ =~ conf_source) then
          @conf = YAML::load(conf_source)
        else
          @conf = YAML::load_file(conf_source)
        end
      end

      def builder
        builder = Ploy::DebBuilder.new(
          :name          => @conf['deploy_name'],
          :sha           => git_revision,
          :branch        => git_branch,
          :timestamp     => git_timestamp,
          :upstart_files => @conf['upstart_files'],
          :dist_dir      => @conf['dist_dir'],
          :prefix        => @conf['prefix'],
          :prep_cmd      => @conf['prep_cmd']
        );
        return builder
      end

      def remote_package
        return Ploy::Package.new(
          @conf['bucket'],
          @conf['deploy_name'],
          git_branch,
          git_revision
        )
      end
    end
  end
end
