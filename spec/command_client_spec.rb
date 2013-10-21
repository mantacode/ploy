require 'rspec/given'
require 'ploy/command/client'
require 'ploy/package'

def fakepkgs
  [
    Ploy::Package.new('bkt', 'one', 'branch', 'version'),
    Ploy::Package.new('bkt', 'two', 'branch', 'version'),
    Ploy::Package.new('bkt', 'three', 'branch', 'version')
  ]
end

describe Ploy::Command::Client do
  Given(:pcc) { Ploy::Command::Client.new }
  context "filtering installable packages" do
    When(:result) { pcc.installable_packages(['one', 'three'], fakepkgs) }
    Then { result.length == 2 }
  end
end
