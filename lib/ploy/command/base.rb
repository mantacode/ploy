module Ploy
  module Command

    # A base class for commands

    class Base

      # sets/gets the argv 

      def argv (v=nil)
        @argv = @argv || v || []
        if v
          return self
        else
          return @argv
        end
      end

      # execute the run command and tries to execute the next command
      
      def execute (argv=[])
        run(argv)
      end

      # run with these arguments

      def run(argv=[])
        return false
      end

      # get the command help

      def help
        return ""
      end

      # the next command
      
      def next (command=nil)
        if command.is_a?(Base)
          @next = command
          return self
        end
        return @next
      end

    end
  end
end

