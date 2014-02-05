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

      def run (argv=[], input='')
        i = info()
        if argv.is_a?(Array) && argv.size > 0
          i += ' ' + argv.join(' ')
        end
        data, err, status = Open3.capture3(i, {stdin_data: input}) 
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
