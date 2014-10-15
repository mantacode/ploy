require 'ploy/command/list'

describe Ploy::Command::List do
  describe "#run" do
    before :each do
      expect_any_instance_of(Ploy::S3Storage).to receive(:list).and_return(["project-name"])
      allow_any_instance_of(Ploy::Package).to receive(:remote_version).and_return('abc')
    end
    it "returns empty JSON object without JSON flag" do
      expect(STDOUT).to receive(:puts).with("project-name master abc abc")
      expect(Ploy::Command::List.new.run(['-b', 'bucket', '-a'])).to eq("[]")
    end
    it "returns JSON object with JSON flag" do
      expect(STDOUT).to receive(:puts).with(/\{\"project-name\":/)
      expect(Ploy::Command::List.new.run(['-b', 'bucket', '-a', '-j'])).to match(/\[\{\"project-name\":/)
    end
    it "does not print up-to-date package info without --all flag" do
      expect(STDOUT).to_not receive(:puts)
      expect(Ploy::Command::List.new.run(['-b', 'bucket'])).to eq("[]")
    end
  end
end
