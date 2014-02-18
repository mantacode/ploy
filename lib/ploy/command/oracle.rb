require 'sinatra'
require 'json'
require 'ploy/metasrc'
require 'ploy/metaoracle'

# TODO: this needs tests. It is a Friday; I just don't have the brainpower
# left to figure out how to test a subclassed sinatra.

module Ploy
  module Command
    class OracleServer < Sinatra::Base
      set :port => 9876
      set :bind => '0.0.0.0'

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
      get '/meta/:stack' do
        [
          200,
          { "Content-type" => "text/json" },
          JSON.dump(Ploy::MetaOracle.new(params[:stack]).query)
        ]
      end
    end

    class Oracle < Base

      def run(argv, input='')
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
