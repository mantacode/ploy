require 'ploy/command/base'

module Ploy
  module Command
    class Publish < Base
      def run(argv)
        Ploy::Publisher.new(argv.shift || '.ploy-publisher.yml').publish
        return true
      end

      def help
        return <<helptext
usage: ploy publish [config.yml]

Examples:

  $ ploy publish
  $ ploy publish something.yml

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

  The publish command takes a config YAML file as input, and uses that to construct a
  debian package file and push it into a particular location in S3

helptext
      end
    end
  end
end