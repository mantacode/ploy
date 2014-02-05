require 'ploy/command/base'
require 'ploy/command/shell'

module Ploy
  module Command
    class Hooks < Base

      def initialize (path='/etc/ploy/events.d')
        @path = path
      end

      def path 
        return @path
      end

      # runs the system command and returns the output of it

      def run (argv=[], input='')
        return 'Needs implemented!'
      end

      # the help information

      def help
        return <<helptext

This command will look for scripts given a path and attempt to execute
them passing the input this command received to each of them.  When all
commands are executed their output is aggregated together and returned.

helptext
      end

    end
  end
end
