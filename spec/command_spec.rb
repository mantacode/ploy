require 'ploy/command'
require 'ploy/command/base'
require 'ploy/command/help'

describe Ploy::Command do
  describe '#lookup' do
    it "should return an instance of ::Help when asked" do
      expect(Ploy::Command.lookup('help')).to be_a(Ploy::Command::Help)
    end
  end
  describe Ploy::Command::Base do
    it "should have a run command that returns false" do
      expect(Ploy::Command::Base.new.run([])).to be_false
    end
    it "should have a help command that returns empty string" do
      expect(Ploy::Command::Base.new.help).to eq('')
    end
  end
end
