require 'publisher'
require 'installer'

module Ploy
  class Cli
    def run(argv)
      subcommand = argv.shift
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
      end
    end
  end
end
