module Ploy
  module Command

    # A base class for commands

    class Base
      # run with these arguments

      def run(argv)
        return false
      end

      # get the command help

      def help
        return ""
      end
    end
  end
end

