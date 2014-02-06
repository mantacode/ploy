require 'ploy/command'
require 'ploy/command/hooks'

module Ploy

  # Cli
  #
  # This is the command line interface.  The default command is "help"

  class Cli
    def run(argv)
      name = argv.shift || 'help'
      # TODO we could also check maybe /etc/ploy/events.d too 
      scripts = [
        File.basename(Dir.getwd) + '/events.d/' + name,
        '/etc/ploy/events.d/' + name
      ]
      Ploy::Command.lookup(name).next(Ploy::Command::Hooks.new(scripts)).execute(argv);
    end
  end
end
