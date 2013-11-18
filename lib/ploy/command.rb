require 'ploy/command/install'
require 'ploy/command/publish'
require 'ploy/command/help'
require 'ploy/command/bless'
require 'ploy/command/oracle'
require 'ploy/command/client'
require 'ploy/command/build'

module Ploy
  module Command
    def self.lookup(topic)
      lookup = {
        'install' => Ploy::Command::Install,
        'bless'   => Ploy::Command::Bless,
        'help'    => Ploy::Command::Help,
        'publish' => Ploy::Command::Publish,
        'oracle'  => Ploy::Command::Oracle,
        'client'  => Ploy::Command::Client,
        'build'   => Ploy::Command::Build,
      }
      mod = lookup[topic] || lookup['help']
      return mod.new
    end
  end
end

