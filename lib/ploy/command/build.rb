require 'ploy/command/base'
require 'ploy/localpackage/config'

module Ploy
  module Command
    class Build < Base
      def run(argv)
        config_source = argv.shift || '.ploy-publisher.yml'
        config = Ploy::LocalPackage::Config.new config_source
        path = config.builder.build_deb
        puts "ploy build deb: #{path}"
        return true
      end

      def help
        return <<helptext
usage: ploy build [config.yml]

Examples:

  $ ploy build
  $ ploy build something.yml

Config Example:

    ---
    bucket: bucketname
    deploy_name: some-project
    dist_dir: spec/resources/dist
    prep_cmd: lineman build
    prefix: /usr/local/someproject
    upstart_files:
     - spec/resources/conf/some-project-initfile

Summary:

Build a deb file.

helptext
      end
    end
  end
end
