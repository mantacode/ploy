require 'ploy/command/base'

module Ploy
  module Command
    class Help < Base
      def run(argv)
        puts Ploy::Command.lookup(argv.shift).help
      end
      def help
        return <<helptext
usage: ploy [command] [options]

Commands:
  publish         Package the current git repository and send to S3
  install         Pull a deployment from S3 and install on current system
  bless           Mark a package as tested for production use
  list            List published packages
  help            Show helps

helptext
      end
    end
  end
end
