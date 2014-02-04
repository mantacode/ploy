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
      # argv should be a hash

      def run (argv={})

        data, err, status = Open3.capture3(info(), argv) 
        print status
        return data.chomp

      end

      # the help information

      def help
        return <<helptext

The command string such as this

$> echo "Hello, World"

Will be executed and the output of the program will be returned

You can also pass in options to the #run method which will be options
to the Open3 capture3 method

helptext
      end

    end
  end
end
