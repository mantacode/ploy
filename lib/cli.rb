require './lib/publisher'

module Ploy
  class Cli
    def run(argv)
      subcommand = argv.shift
      if (subcommand == "publish") then
        filename = argv.shift
        if (not filename) then
          filename = ".ploy-publisher.yml"
        end
        Ploy::Publisher.new(filename).publish
      end
    end
  end
end
