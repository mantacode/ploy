require 'sinatra'
require 'json'
require 'ploy/metasrc'

module Ploy
  module Command
    class OracleServer < Sinatra::Base
      def self.oracle_run(metasrc)
        @@metasrc = metasrc # this could not be sadder
        run!
      end
      get '/' do
        [
          200,
          { "Content-type" => "text/json" },
          JSON.dump(@@metasrc.load)
        ]
      end
    end
    class Oracle < Base
      def run(argv)
        OracleServer.oracle_run Ploy::MetaSrc.new(argv.shift || '/etc/ploy/metadata.d')
      end
      def help
        return <<helptext
usage: ploy oracle [dir]

Examples:

  $ ploy oracle /etc/ploy/metadata.d

Summary:

  The oracle command starts up an http server. When it receives a GET request, it
  will read all of the metadata files in [dir] and return the data in them to
  the client as json.

helptext
      end
    end
  end
end
