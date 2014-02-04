require 'open3'
require 'ploy/command/base'

module Ploy
  module Command
    class Shell < Base

      def initialize (info='echo "default command"')
        @info = info
      end

      def info 
        return @info
      end

      # runs the system command and returns the output of it

      def run (argv)

        # Id like to have the option of passing the stdin data.  so we can
        # chain these commands together
        data, err, status = Open3.capture3(info(), :stdin_data=>'') 
        print status
        return data.chomp

      end

      # the help information

      def help
        return <<helptext

The command string such as this

$> echo "Hello, World"

Will be executed and the output of the program will be returned

helptext
      end

    end
  end
end
