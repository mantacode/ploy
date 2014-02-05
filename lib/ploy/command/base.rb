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

      # executes the run command.  If we have a next command we will call execute
      # on the next command passing in the result of our run command.  If we
      # have a next command we will return the result of the call from that command
      # or we will just return the result of our run command

      def execute (p=[], input='')
        out = run(p.size > 0 ? p : argv(), input)
        n = self.next()
        if n
          # Maybe a command should be able to "grab" their arguments from somewhere
          # so they can be dynamic?
          return n.execute([], out)
        else
          return out
        end
      end

      # run with these arguments

      def run(argv=[], input='')
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

