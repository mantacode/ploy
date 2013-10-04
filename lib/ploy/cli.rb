require 'ploy/installer'
require 'ploy/publisher'
require 'ploy/command'

module Ploy
  class Cli
    def run(argv)
      subcommand = argv.shift || 'help'
      Ploy::Command.lookup(subcommand).run(argv)
    end
  end
end
