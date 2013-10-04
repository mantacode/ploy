require 'ploy/command'

describe Ploy::Command::Base do
  it "should have a run command that returns false" do
    expect(Ploy::Command::Base.new.run([])).to be_false
  end
  it "should have a help command that returns empty string" do
    expect(Ploy::Command::Base.new.help).to eq('')
  end
end
