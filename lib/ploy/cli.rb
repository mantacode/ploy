require 'ploy/command'
require 'ploy/command/hooks'

module Ploy

  # Cli
  #
  # This is the command line interface.  The default command is "help"

  class Cli
    def run(argv)
      name = argv.shift || 'help'
      scripts = [
        File.basename(Dir.getwd) + '/events.d',
        '/etc/ploy/events.d'
      ]
      Ploy::Command.lookup(name).next(Ploy::Command::Hooks.new(scripts, name)).execute(argv);
    end
  end
end
