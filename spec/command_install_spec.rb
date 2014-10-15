require 'ploy/command/install'

describe Ploy::Command::Install do
  describe "#run" do
    it "will run Package#install with correct arguments and return true" do
      argv = ['-b', 'bucket', '-d', 'deploy', '-B', 'branch', '-v', 'version']      
      expect_any_instance_of(Ploy::Package).to receive(:install)
      expect_any_instance_of(Ploy::Package).to receive(:check_new_version).and_return('abcde')
      expect(STDOUT).to receive(:puts).with('installed deploy')
      expect(Ploy::Command::Install.new.run argv).to be true
    end
  end
  describe "#help" do
    it "will return a non-empty help string" do
      expect(Ploy::Command::Install.new.help).to match(/.+/) # meh
    end
  end
end
