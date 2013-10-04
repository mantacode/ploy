require './lib/ploy/command'

describe Ploy::Command do
  it "should have a run command that returns false" do
    expect(Ploy::Command.new.run({})).to be_false
  end
end
