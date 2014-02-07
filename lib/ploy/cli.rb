require 'ploy/command'

module Ploy

  # Cli
  #
  # This is the command line interface.  The default command is "help"

  class Cli
    def run(argv)
      subcommand = argv.shift || 'help'
      Ploy::Command.lookup(subcommand).run(argv)
    end
  end
end
