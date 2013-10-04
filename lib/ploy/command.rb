require 'ploy/command/install'
require 'ploy/command/publish'
require 'ploy/command/help'
require 'ploy/command/oracle'

module Ploy
  module Command
    def self.lookup(topic)
      lookup = {
        'install' => Ploy::Command::Install,
        'help'    => Ploy::Command::Help,
        'publish' => Ploy::Command::Publish,
        'oracle'  => Ploy::Command::Oracle,
      }
      mod = lookup[topic] || lookup['help']
      return mod.new
    end
  end
end

