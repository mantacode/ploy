require 'ploy/command/base'
require 'ploy/publisher'

module Ploy
  module Command
    class Publish < Base
      def run(argv)
        res = Ploy::Publisher.new(argv.shift || '.ploy-publisher.yml').publish
        puts "ploy publish (#{res.deploy_name} #{res.branch} #{res.version}) ok"
        puts "debug: git rev-parse: #{`git rev-parse HEAD`.chomp}"
        puts "debug: git symbolic-ref: #{`git symbolic-ref --short -q HEAD`.chomp}"
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
