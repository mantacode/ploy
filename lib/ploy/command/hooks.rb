require 'ploy/command/base'
require 'ploy/command/shell'

module Ploy
  module Command
    class Hooks < Base

      def initialize (paths=['/etc/ploy/events.d'], event='')
        @paths = paths
        @event = event
      end

      def paths 
        @paths
      end

      def event
        @event
      end

      # runs the system command and returns the output of it

      def run (argv=[], input='')
        output = []
        paths.each do |path|
          if event.size > 0
            path += '/' + event
          end
          Dir.foreach(path) do |item|
            next if item == '.' or item == '..'
            name = path + '/' + item
            if !File.directory?(name) && File.executable?(name)
              out = Shell.new(name).execute([], input)
              output.push(name + "\n" + out);
            end
          end
        end
        return output.join("\n")
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
