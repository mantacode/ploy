require 'ploy/command/base'
require 'ploy/publisher'

module Ploy
  module Command
    class Publish < Base
      def run(argv)
        if not is_pull_request_build then
          published = Ploy::Publisher.new(argv.shift || '.ploy-publisher.yml').publish
          if published.length > 0 then
            published.each do |res|
              puts "ploy publish (#{res.deploy_name} #{res.branch} #{res.version}) ok"
            end
          end
          #puts "debug: git rev-parse: #{`git rev-parse HEAD`.chomp}"
          #puts "debug: git symbolic-ref: #{`git symbolic-ref -q HEAD |sed -e 's/.*\\///'`.chomp}"
        else
          puts "skipping publish; this is a PR build"
        end
        return true
      end

      def is_pull_request_build()
        prenv = ENV['TRAVIS_PULL_REQUEST']
        return prenv && (prenv != 'false')
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
