require 'ploy/command/install'
require 'ploy/command/help'

module Ploy
  module Command
    def self.lookup(topic)
      lookup = {
        'install' => Ploy::Command::Install,
        'help'    => Ploy::Command::Help
        #'publish' => Ploy::Command::Publish,
      }
      mod = lookup[topic] || lookup['help']
      return mod.new
    end
  end
end

