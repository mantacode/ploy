require 'publisher'
require 'installer'

module Ploy
  class Cli
    def run(argv)
      subcommand = argv.shift || 'help'
      # obvs a serious of if statements is lame. refactor later.
      if (subcommand == "publish") then
        filename = argv.shift
        if (not filename) then
          filename = ".ploy-publisher.yml"
        end
        Ploy::Publisher.new(filename).publish
      elsif (subcommand == "install") then
        bucket, deploy, branch, version = argv
        Ploy::Installer.install(bucket, deploy, branch, version)
      elsif (subcommand == "help") then
        text = <<-helptext
usage: ploy [command] [options]

Commands:
  publish         Package the current git repository and send to S3
  install         Pull a deployment from S3 and install on current system
  help            Show help
        helptext
        puts text
      end
    end
  end
end
