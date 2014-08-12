require 'ploy/command/install'

describe Ploy::Command::Install do
  describe "#run" do
    it "will run Package#install with correct arguments and return true" do
      Ploy::Package.any_instance.should_receive(:install)
      argv = ['-b', 'bucket', '-d', 'deploy', '-B', 'branch', '-v', 'version']
      Ploy::Package.any_instance.should_receive(:check_new_version) { 'abcde' }
      expect(Ploy::Command::Install.new.run(argv)).to be true
    end
  end
  describe "#help" do
    it "will return a non-empty help string" do
      expect(Ploy::Command::Install.new.help).to match(/.+/) # meh
    end
  end
end
