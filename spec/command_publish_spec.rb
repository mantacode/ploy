require 'ploy/command/publish'

describe Ploy::Command::Publish do
  describe "#run" do
    it "will run Publisher#publish with correct arguments and return true" do
      pub = double("publisher")
      expect(pub).to receive(:publish).and_return([])
      expect(Ploy::Publisher).to receive(:new).with('test.yml').and_return(pub)
      expect_any_instance_of(Ploy::Command::Publish).to receive(:is_pull_request_build).and_return(false)
      expect(Ploy::Command::Publish.new.run ['test.yml']).to be true
    end
  end
  describe "#help" do
    it "will return a non-empty help string" do
      expect(Ploy::Command::Publish.new.help).to match(/.+/) # meh
    end
  end
end
