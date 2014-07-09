module Ploy
  module Command
    class Base
      def run(argv)
        return false
      end

      def help
        return ""
      end
    end
  end
end

