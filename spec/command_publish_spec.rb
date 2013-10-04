require 'ploy/command/publish'

describe Ploy::Command::Publish do
  describe "#run" do
    it "will run Publisher#publish with correct arguments and return true" do
      pub = double("publisher")
      pub.should_receive(:publish)
      Ploy::Publisher.should_receive(:new).with("test.yml") { pub }

      argv = ["test.yml"]
      expect(Ploy::Command::Publish.new.run(argv)).to be_true
    end
  end
  describe "#help" do
    it "will return a non-empty help string" do
      expect(Ploy::Command::Publish.new.help).to match(/.+/) # meh
    end
  end
end
