require 'ploy/command'
require 'ploy/command/hooks'

module Ploy

  # Cli
  #
  # This is the command line interface.  The default command is "help"

  class Cli
    def run(argv)
      name = argv.shift || 'help'
      scripts = File.basename(Dir.getwd) + '/events.d'
      puts 'the scripts: ' + scripts
      Ploy::Command.lookup(name).next(Ploy::Command::Hooks.new(scripts)).execute(argv);
      Ploy::Command.lookup(subcommand).run(argv)
    end
  end
end
